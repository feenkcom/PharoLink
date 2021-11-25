Class {
	#name : #PharoLinkServerConnection,
	#superclass : #Object,
	#instVars : [
		'socket',
		'stream',
		'debugMode',
		'server',
		'listenProcess',
		'syncRegistry'
	],
	#category : #'PharoLink-Server'
}

{ #category : #'instance creation' }
PharoLinkServerConnection class >> server: aPharoLinkServer socket: aSocket [

	^ self new initializeServer: aPharoLinkServer socket: aSocket
]

{ #category : #private }
PharoLinkServerConnection >> deserialize: aByteArray [

	^ server deserialize: aByteArray
]

{ #category : #accessing }
PharoLinkServerConnection >> globals [

	^ server globals
]

{ #category : #private }
PharoLinkServerConnection >> handlEnqueue: aDictionary [
	"Process the supplied statements"
	| command |

	command := PharoLinkEvalCommand
					source: (aDictionary at: #'statements')
					bindings: ((aDictionary at: #'bindings') asDictionary collect: [ :obj |
						self deserialize: obj ])
					id: (aDictionary at: #'commandId').
	command connection: self.
	StringSignal emit: 'Enqueue: ', aDictionary printString.

"self halt: (dict at: #statements)."
	[ command execute: self globals ] forkAt: Processor userSchedulingPriority.

]

{ #category : #private }
PharoLinkServerConnection >> handleIsAlive: aDictionary [
	"Respond to the ping request"
	| response |

	StringSignal emit: '#IS_ALIVE'.
	response := { #type -> #IS_ALIVE } asDictionary.
	self sendResponse: response to: aDictionary.
]

{ #category : #public }
PharoLinkServerConnection >> handleRequest: aDictionary [
	| type syncId registryEntry |

	type := aDictionary at: #type.
	type = #'ENQUEUE' ifTrue: [ ^ self handlEnqueue: aDictionary ].
	type = #'IS_ALIVE' ifTrue: [ ^ self handleIsAlive: aDictionary ].
	"ERR should possibly be handled as a general sync message"
	type = #'ERR' ifTrue: [ "No action for now" ^ self halt ].

	"The message is expected to be a sync message"
	aDictionary 
		at: #'__sync'
		ifPresent: [ :id | syncId := id ]
		ifAbsent: [ self error: 'Unknown request type: ', type printString ].

	registryEntry := syncRegistry at: syncId.
	registryEntry result: (self deserialize: (aDictionary at: #value)).
	registryEntry signal.
]

{ #category : #initialization }
PharoLinkServerConnection >> initialize [ 

	super initialize.
	syncRegistry := Dictionary new.
]

{ #category : #initialization }
PharoLinkServerConnection >> initializeServer: aPharoLinkServer socket: aSocket [

	server := aPharoLinkServer.
	socket := aSocket.
	self start.
]

{ #category : #accessing }
PharoLinkServerConnection >> registry [ 

	^ server registry
]

{ #category : #private }
PharoLinkServerConnection >> sendAsyncMessage: msgDictionary [

	StringSignal emit: 'Send async message ', msgDictionary printString.
	stream nextPut: msgDictionary.
]

{ #category : #private }
PharoLinkServerConnection >> sendResponse: responseDictionary to: msgDictionary [

	(responseDictionary at: #type) = (msgDictionary at: #type) ifFalse:
		[ self error: 'Invalid response' ].
	responseDictionary at: #'__sync' put: (msgDictionary at: #'__sync').
	stream nextPut: responseDictionary.
]

{ #category : #private }
PharoLinkServerConnection >> sendSyncMessage: msgDictionary [
	| syncId registryEntry |

	StringSignal emit: 'Send sync message ', msgDictionary printString.
	syncId := UUIDGenerator next base64Encoded.
	msgDictionary at: #'__sync' put: syncId.
	registryEntry := PharoServerSyncRegistryEntry id: syncId.
	syncRegistry at: syncId put: registryEntry.
	stream nextPut: msgDictionary.
	registryEntry wait.
	syncRegistry removeKey: syncId.
	^ registryEntry result.
]

{ #category : #private }
PharoLinkServerConnection >> stackString [

	^ String streamContents: [ :stackStream |
		thisContext stack do: [ :stackItem |
			stackStream print: stackItem; cr ] ]
]

{ #category : #'start-stop' }
PharoLinkServerConnection >> start [

	stream := LanguageLinkMsgPackSocketStream on: (SocketStream on: socket).
	listenProcess := 
		[ [ [ 	self handleRequest: stream next ] repeat ]
			on: Error 
			do: [ :ex | LanguageLinkCommunicationsSignal new
				originalException: ex;
				stackString: self stackString;
				emit ] ]
					forkAt: Processor userSchedulingPriority
					named: 'PharoLinkServerConnection listenProcess'.
	StringSignal emit: 'PharoLink connection accepted'.
]

{ #category : #'start-stop' }
PharoLinkServerConnection >> stop [ 

	socket ifNotNil: [ socket closeAndDestroy ].
	listenProcess ifNotNil: [ listenProcess terminate ].
	socket := nil.
	listenProcess := nil.
]