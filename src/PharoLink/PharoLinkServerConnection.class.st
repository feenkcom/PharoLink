Class {
	#name : #PharoLinkServerConnection,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'socket',
		'stream',
		'debugMode',
		'server',
		'listenProcess',
		'syncRegistry',
		'processes',
		'announcer',
		'registry'
	],
	#category : #'PharoLink-Server'
}

{ #category : #'instance creation' }
PharoLinkServerConnection class >> server: aPharoLinkServer socket: aSocket [

	^ self new initializeServer: aPharoLinkServer socket: aSocket
]

{ #category : #announcer }
PharoLinkServerConnection >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #private }
PharoLinkServerConnection >> deserialize: aByteArray [

	^ PharoLinkServerSerializer deserialize: aByteArray registry: registry
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
		           source: (aDictionary at: #statements)
		           bindings:
			           ((aDictionary at: #bindings) asDictionary collect: [ 
				            :obj | self deserialize: obj ])
		           id: (aDictionary at: #commandId).
	command connection: self.
	StringSignal emit: 'Enqueue: ' , aDictionary printString.
	processes add: ([ 
		 PharoLinkServerCurrentConnection
			 value: self
			 during: [ command execute: self globals ] ] forkAt:
			 Processor userSchedulingPriority)
]

{ #category : #'error handling' }
PharoLinkServerConnection >> handleError: aDictionary [

	PharoLinkErrorRequestSignal new
		dictionary: aDictionary;
		emit.
	aDictionary
		at: #action
		ifPresent: [ :anotherDictionary |
			anotherDictionary
				at: #action
				ifPresent: [ :action |
					action = #DROP_QUEUE ifTrue:
						[ (syncRegistry at: (aDictionary at: #__sync)) signal ]
					ifFalse:
						[ self error: 'Unknown action' ] ]
				ifAbsent: [ self error: 'Expected an action command' ] ]
		ifAbsent:
			[ self error: 'Expected an action' ]

]

{ #category : #private }
PharoLinkServerConnection >> handleIsAlive: aDictionary [
	"Respond to the ping request"
	| response |

	StringSignal emit: '#IS_ALIVE'.
	response := { #type -> #IS_ALIVE } asDictionary.
	self sendResponse: response to: aDictionary.
]

{ #category : #private }
PharoLinkServerConnection >> handleNextRequestSafely [
	"Retrieve the next request and process it,
	handling connection errors and timeouts"

	^ [ self handleRequest: stream next ]
		on: ConnectionClosed, ConnectionTimedOut
		do: [ :ex |
			"Stop the receiver and announce it.
			Run from a separate process since we are inside the listen process, and would kill the stop :-)"
			[ self stop ] fork.
			"Wait to be terminated"
			Semaphore new wait ]
]

{ #category : #public }
PharoLinkServerConnection >> handleRequest: aDictionary [
	| type syncId registryEntry |

	type := aDictionary at: #type.
	type = #'ENQUEUE' ifTrue: [ ^ self handlEnqueue: aDictionary ].
	type = #'IS_ALIVE' ifTrue: [ ^ self handleIsAlive: aDictionary ].
	"ERR should possibly be handled as a general sync message"
	type = #'ERR' ifTrue: [ ^ self handleError: aDictionary ].

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
	announcer := Announcer new.
	registry := PharoLinkRegistry new.
	processes := WeakIdentitySet new
]

{ #category : #initialization }
PharoLinkServerConnection >> initializeServer: aPharoLinkServer socket: aSocket [

	server := aPharoLinkServer.
	socket := aSocket.
	self start.
]

{ #category : #accessing }
PharoLinkServerConnection >> registry [ 

	^ registry
]

{ #category : #accessing }
PharoLinkServerConnection >> remoteAddress [

	^ socket 
		ifNil: [ ByteArray new: 4 ]
		ifNotNil: [ socket remoteAddress ]
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
		[ PharoLinkServerCurrentConnection value: self during:
			[ [ [ 	self handleNextRequestSafely ] repeat ]
				on: Error 
				do: [ :ex | LanguageLinkCommunicationsSignal new
					originalException: ex;
					stackString: self stackString;
					emit ] ] ]
						forkAt: Processor userSchedulingPriority
						named: 'PharoLinkServerConnection listenProcess'.
	StringSignal emit: 'PharoLink connection accepted'.
]

{ #category : #'start-stop' }
PharoLinkServerConnection >> stop [

	listenProcess ifNotNil: #terminate.
	listenProcess := nil.
	socket ifNotNil: #closeAndDestroy.
	socket := nil.
	processes do: [ :e | 
		[ e terminate ]
			on: ProcessAlreadyTerminating
			do: [ "noop" ] ].
	processes removeAll.
	self announce:
		(PharoLinkServerConnectionDisconnectedAnnouncement connection: self)
]
