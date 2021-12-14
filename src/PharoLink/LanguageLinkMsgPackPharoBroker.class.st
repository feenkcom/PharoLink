Class {
	#name : #LanguageLinkMsgPackPharoBroker,
	#superclass : #PharoLinkAbstractMessageBroker,
	#instVars : [
		'socket',
		'handlerThread',
		'msgStream',
		'syncRegistry'
	],
	#category : #'PharoLink-MessageBroker'
}

{ #category : #accessing }
LanguageLinkMsgPackPharoBroker class >> javaScriptMethodArg [
	^ 'msgpack'
]

{ #category : #accessing }
LanguageLinkMsgPackPharoBroker class >> serializerClass [

	^ LanguageLinkMsgPackSerializer
]

{ #category : #'private - utils' }
LanguageLinkMsgPackPharoBroker >> clientSocket [
	| socketAddress newSocket retryDelay retryCount |

	socketAddress := self settings serverSocketAddress.
	(newSocket := Socket newTCP)
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: LanguageLinkMsgPackUtils socketBufferSize;
		setOption: 'SO_RCVBUF' value: LanguageLinkMsgPackUtils socketBufferSize .
	retryCount := 20.
	retryDelay := 500 milliSeconds.
	[ [ newSocket connectToHostNamed: socketAddress ipOrName port: socketAddress port ]
		on: ConnectionTimedOut
		do: [].
	newSocket isConnected or: [ retryCount = 0 ] ] whileFalse:
		[ retryDelay wait.
		retryCount := retryCount - 1 ].
	newSocket isConnected
		ifFalse: [ self error: 'Cannot connect to ', socketAddress printString ].
	^ newSocket
]

{ #category : #private }
LanguageLinkMsgPackPharoBroker >> handleAnswerMessage: dict [
	| assoc message semaphore |
	assoc := syncRegistry at: (dict at: #__sync).
	message := assoc key.
	semaphore := assoc value.
	syncRegistry at: message syncId put: (message createAnswer decode: dict).
	semaphore signal
]

{ #category : #initialization }
LanguageLinkMsgPackPharoBroker >> initialize [
	super initialize.
	syncRegistry := Dictionary new
]

{ #category : #testing }
LanguageLinkMsgPackPharoBroker >> isRunning [
	^ msgStream notNil and: [ msgStream isConnected ]
]

{ #category : #private }
LanguageLinkMsgPackPharoBroker >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: handlerThread 
			ifAbsent: [  ] ]
]

{ #category : #private }
LanguageLinkMsgPackPharoBroker >> primHandle: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	msgClass isReverseMessage
		ifTrue: [ | handler |
			handler := self handle: dict reverseMessageClass: msgClass.
			handler shouldAnswer ifTrue: [ self primSendMessage: handler answer encode ] ]
		ifFalse: [ 
			self handleAnswerMessage: dict ]
]

{ #category : #private }
LanguageLinkMsgPackPharoBroker >> primSendMessage: dict [
	msgStream ifNil: [ LanguageLinkCommunicationError signal ].
	msgStream nextPut: dict
]

{ #category : #private }
LanguageLinkMsgPackPharoBroker >> registerSemaphoreForMessage: message [
	| semaphore |
	semaphore := Semaphore new.
	syncRegistry at: message syncId put: message -> semaphore.
	^ semaphore
]

{ #category : #private }
LanguageLinkMsgPackPharoBroker >> retrieveAnswerForSyncId: syncId [
	| msgAnswer |
	msgAnswer := syncRegistry at: syncId.
	syncRegistry removeKey: syncId.
	^ msgAnswer
]

{ #category : #messaging }
LanguageLinkMsgPackPharoBroker >> sendAsyncMessage: msg [

	self primSendMessage: msg encode.
]

{ #category : #messaging }
LanguageLinkMsgPackPharoBroker >> sendSyncMessage: msg [
	| syncSemaphore ansDict |
	syncSemaphore := self registerSemaphoreForMessage: msg. 
	self primSendMessage: msg encode.
	syncSemaphore wait.
	ansDict := self retrieveAnswerForSyncId: msg syncId.
	^ msg createAnswer decode: ansDict
]

{ #category : #'private - utils' }
LanguageLinkMsgPackPharoBroker >> serverSocketOn: port [
	| socket |
	(socket := Socket newTCP)
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: LanguageLinkMsgPackUtils socketBufferSize;
		setOption: 'SO_RCVBUF' value: LanguageLinkMsgPackUtils socketBufferSize .
	socket listenOn: port backlogSize: LanguageLinkMsgPackUtils listenBacklogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : #'start-stop' }
LanguageLinkMsgPackPharoBroker >> start [

	socket := self clientSocket.
	handlerThread := [ 
	                 [ 
	                 msgStream := LanguageLinkMsgPackSocketStream on:
		                              (SocketStream on: socket).
	                 [ self primHandle: msgStream next ] repeat ]
		                 on: NetworkError
		                 do: [ :error | 
		                 Halt once.
		                 error emit. ] ] forkNamed:
		                 'LanguageLinkMsgPackPharoBroker handlerThread'
]

{ #category : #'start-stop' }
LanguageLinkMsgPackPharoBroker >> stop [

	msgStream ifNotNil: #close.
	socket ifNotNil: #closeAndDestroy.
	handlerThread ifNotNil: #terminate.
	msgStream := socket := handlerThread := nil
]
