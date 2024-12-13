Class {
	#name : #PharoLinkServerConnection,
	#superclass : #Object,
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
PharoLinkServerConnection >> announce: anAnnouncement [

	^ self announcer announce: anAnnouncement
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
PharoLinkServerConnection >> handleNextRequestConnectionErrors: aRequestDictionary [
	"Retrieve the next request and process it,
	handling connection errors and timeouts"

	^ [ self handleRequest: aRequestDictionary ]
		on: ConnectionClosed, ConnectionTimedOut, SocketError
		do: [ :ex |
			"Stop the receiver and announce it.
			Run from a separate process since we are inside the listen process, and would kill the stop :-)"
			[ self stop ] fork.
			"Give the stop a chance to run"
			1 second wait ]
]

{ #category : #private }
PharoLinkServerConnection >> handleNextRequestSafely [
	"Retrieve the next request and process it.
	Pass any errors (other than connection related) back to the client"
	| request |

	^ [ "Explicitly nil the request to ensure an exception while getting the next request doesn't result in the previous request being passed to the exception handler"
		request := nil.
		request := stream next.
		self handleNextRequestConnectionErrors: request ]
			on: Error
			do: [ :ex | self notifyError: ex in: request ]
]

{ #category : #private }
PharoLinkServerConnection >> handlEnqueue: aDictionary [
	"Process the supplied statements"
	| command bindings |

	bindings := Dictionary new.
	(aDictionary at: #bindings) keysAndValuesDo: [ :key :value |
		bindings
			at: key asSymbol
			put: (self deserialize: value) ].
	command := PharoLinkEvalCommand
		           source: (aDictionary at: #statements)
		           bindings: bindings
		           id: (aDictionary at: #commandId).
	command connection: self.
	processes add: ([ 
		 PharoLinkServerCurrentConnection
			 value: self
			 during: [ command execute: self globals ] ] forkAt:
			 Processor userSchedulingPriority)
]

{ #category : #public }
PharoLinkServerConnection >> handleRequest: aDictionary [
	| type syncId registryEntry |

	type := aDictionary at: #type.
	type = 'ENQUEUE' ifTrue: [ ^ self handlEnqueue: aDictionary ].
	type = 'IS_ALIVE' ifTrue: [ ^ self handleIsAlive: aDictionary ].	"ERR should possibly be handled as a general sync message"
	type = 'ERR' ifTrue: [ ^ self handleError: aDictionary ].	"The message is expected to be a sync message"
	aDictionary
		at: #__sync
		ifPresent: [ :id | syncId := id ]
		ifAbsent: [ self error: 'Unknown request type: ' , type printString ].

	registryEntry := syncRegistry at: syncId.
	registryEntry result: (self deserialize: (aDictionary at: #value)).
	registryEntry signal
]

{ #category : #announcer }
PharoLinkServerConnection >> hasSubscriber: anObject [

	^ self announcer hasSubscriber: anObject
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
	Stdio stdout 
		lf; 
		<< 'SO_KEEPALIVE: ';
		<< (socket setOption: #SO_KEEPALIVE value: 1) printString;
		lf.
	self start.
]

{ #category : #testing }
PharoLinkServerConnection >> isConnected [

	^ socket isNotNil and: [ socket isConnected ]
]

{ #category : #testing }
PharoLinkServerConnection >> isRunning [

	^ self isConnected and: [ listenProcess isNotNil and:
		[ listenProcess isTerminated not ] ]
]

{ #category : #accessing }
PharoLinkServerConnection >> localAddressWithPortString [
	socket ifNil: [ ^ '<none>' ].

	^ String streamContents: [ :aStream |
		socket localAddress printOn: aStream delimiter: '.'.
		aStream 
			<< ':';
			print: socket localPort  ]
]

{ #category : #private }
PharoLinkServerConnection >> notifyError: error in: aRequestDictionary [
	"Notify the client of the error encountered during evaluation"
	| id data |

	self isConnected ifFalse: [ ^ self ].
	"NetworkErrors typically mean that the client has gone away, just log and move on"
	(error isKindOf: NetworkError) ifTrue: [ 
		PharoLinkNetworkErrorSignal emitCommand: self error: error.
		^ self ].

	id := aRequestDictionary at: 'commandId' ifAbsent: [ '<unknown>' ].
	data := Dictionary new.
	data 	
		at: 'type' put: 'ERR';
		at: 'errMsg' put: error printString;
		at: 'commandId' put: id;
		at: 'trace' put: self stackString.
	^ [ self sendSyncMessage: data ]
		on: Error 
		do: [ :ex | | commsError |
			commsError := LanguageLinkCommunicationsSignal new
				originalException: error;
				commandId: id;
				stackString: self stackString.
			commsError emit ].
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

{ #category : #accessing }
PharoLinkServerConnection >> remoteAddressString [
	"Answer the usual dot notation of the supplied IPv4 address"

	socket ifNil: [ ^ '<none>' ].

	^ String streamContents: [ :aStream |
		self remoteAddress printOn: aStream delimiter: '.' ]
]

{ #category : #accessing }
PharoLinkServerConnection >> remoteAddressWithPortString [
	socket ifNil: [ ^ '<none>' ].

	^ String streamContents: [ :aStream |
		self remoteAddress printOn: aStream delimiter: '.'.
		aStream 
			<< ':';
			print: socket remotePort  ]
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> removeSubscription: subscription [
	"Remove the given subscription from the receiver"

	^ self announcer removeSubscription: subscription
]

{ #category : #private }
PharoLinkServerConnection >> sendAsyncMessage: msgDictionary [

	stream nextPut: msgDictionary.
]

{ #category : #private }
PharoLinkServerConnection >> sendResponse: responseDictionary to: msgDictionary [
	((responseDictionary at: #type) sameContentAs: (msgDictionary at: #type))
		ifFalse: [ self error: 'Invalid response' ].
	responseDictionary at: #__sync put: (msgDictionary at: #__sync).
	stream nextPut: responseDictionary
]

{ #category : #private }
PharoLinkServerConnection >> sendSyncMessage: msgDictionary [
	| syncId registryEntry |

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
			[ [ [ self isConnected ] whileTrue:
				[ self handleNextRequestSafely ] ]
				on: Error 
				do: [ :ex | 
					ex logStackToFile.
					LanguageLinkCommunicationsSignal new
						originalException: ex;
						stackString: self stackString;
						emit ] ] ]
							forkAt: Processor userSchedulingPriority
							named: 'PharoLinkServerConnection listenProcess'.
							
	StringSignal emit: 'PharoLink connection accepted'.
]

{ #category : #'start-stop' }
PharoLinkServerConnection >> stop [
	"Stop the receiver.
	This is called by #handleNextRequestSafely when the connection is closed.
	Notify the server (which may cause it to quit the image)."

	listenProcess ifNotNil: #terminate.
	listenProcess := nil.
	socket ifNotNil: #closeAndDestroy.
	socket := nil.
	syncRegistry valuesDo: [ :entry | entry signalConnectionLost ].
	processes do: [ :e | 
		[ e terminate ]
			on: ProcessAlreadyTerminating
			do: [ "noop" ] ].
	processes removeAll.
	self announce:
		(PharoLinkServerConnectionDisconnectedAnnouncement connection: self).
	server onConnectionStopped: self.
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	^ self announcer unsubscribe: anObject
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> weak [
	"announcer weak subscribe: foo"

	^ self announcer weak
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that ushc method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."

		^ self announcer when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ (self when: anAnnouncementClass do: aValuable) subscriber: aSubscriber; yourself.
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> when: anAnnouncementClass doOnce: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"
	
	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"

		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #'announcer - subscription' }
PharoLinkServerConnection >> when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber.
]
