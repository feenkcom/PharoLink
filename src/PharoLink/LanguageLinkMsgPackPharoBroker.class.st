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
LanguageLinkMsgPackPharoBroker class >> methodArg [
	^ 'msgpack'
]

{ #category : #accessing }
LanguageLinkMsgPackPharoBroker class >> serializerClass [

	^ LanguageLinkMsgPackSerializer
]

{ #category : #'private - utils' }
LanguageLinkMsgPackPharoBroker >> clientSocket [
	| socketAddress newSocket retryCount serverIP |
	socketAddress := self settings serverSocketAddress.
	"Wait up to `((25 to: 1 by: -1) collect: [ :each | (5.0 / each) seconds ]) sum` seconds for the server to come up"
	retryCount := 25.
	serverIP := NetNameResolver addressForName: socketAddress ipOrName timeout: 20.
	[ 
		LlEsConnectStartingSignal new
			emit.
		[ 
			(newSocket := Socket newTCP)
				setOption: 'TCP_NODELAY' value: 1;
				setOption: 'SO_SNDBUF' value: LanguageLinkMsgPackUtils socketBufferSize;
				setOption: 'SO_RCVBUF' value: LanguageLinkMsgPackUtils socketBufferSize .
			newSocket 
				connectTo: serverIP
				port: socketAddress port
				waitForConnectionFor: 10 ]
			on: ConnectionTimedOut
			do: [ :ex | 
				"Ignored by design"
				"Stdio stdout
					lf;
					<< 'LanguageLinkMsgPackPharoBroker>>#clientSocket: ConnectionTimedOut, retries left ';
					<< retryCount printString;
					lf" ].
		LlEsConnectCompletedSignal new
			isConnected: newSocket isConnected;
			emit.
		newSocket isConnected or: [ retryCount < 1 ] ] whileFalse:[ 
			(5.0 / retryCount) seconds wait.
			retryCount := retryCount - 1 ].
	newSocket isConnected
		ifFalse: [ ConnectionTimedOut signal: 
						('{1} cannot connect to {2}' format: {
							self class name . socketAddress }) ].
	^ newSocket
]

{ #category : #'gt - extensions' }
LanguageLinkMsgPackPharoBroker >> gtViewBrokerSettingsFor: aView [
	<gtView>
	 
	^ aView forward
		title: 'Settings';
		object: [ settings ];
		view: #gtSettingsFor:
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

{ #category : #accessing }
LanguageLinkMsgPackPharoBroker >> handleMessages [
	"This needs appropriate error handling.
	If the receiver has been told to shut down, errors can probably be ignored."

	settings connectionExceptionHandler 
		handleExceptionsDuring: [ [ self primHandle: msgStream next ] repeat ]
		for: self.
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

{ #category : #accessing }
LanguageLinkMsgPackPharoBroker >> remoteAddressString [

	^ String streamContents: [ :stream |
		socket remoteAddress printOn: stream delimiter: '.'.
		stream
			nextPut: $:;
			print: socket remotePort ]
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
		msgStream := LanguageLinkMsgPackSocketStream on: (SocketStream on: socket).
		self handleMessages.
		] forkNamed: 'LanguageLinkMsgPackPharoBroker handlerThread'.

]

{ #category : #'start-stop' }
LanguageLinkMsgPackPharoBroker >> stop [

	msgStream ifNotNil: #close.
	handlerThread ifNotNil: #terminate.
	socket ifNotNil: #closeAndDestroy.
	msgStream := socket := handlerThread := nil
]
