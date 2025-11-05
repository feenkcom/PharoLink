"
This class contains tests

"
Class {
	#name : #LanguageLinkMsgPackSocketStreamTest,
	#superclass : #TestCase,
	#category : 'PharoLink-MessageBroker'
}

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> assertSerialize: anObject [
	self connectStreams: [ :serverStream :clientStream |
		clientStream nextPut: anObject.
		self assert: (serverStream next sameContentAs: anObject).
		self deny: serverStream atEnd ]
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> connectStreams: aBlock [
	| semaphore clientSocket serverStream clientStream |
	self serverSocket: [ :serverSocket |
		semaphore := Semaphore new.
		[ 	clientSocket := serverSocket waitForAcceptFor: 10.
			semaphore signal. ] forkAt: self serverPriority.
		[	clientStream := LanguageLinkMsgPackUtils openConnectionToHost: #[ 127 0 0 1 ] port: self port.
			semaphore wait.
			[	serverStream := LanguageLinkMsgPackUtils primStreamFromSocket: clientSocket.
				aBlock 
					value: (LanguageLinkMsgPackSocketStream on: serverStream) 
					value: (LanguageLinkMsgPackSocketStream on: clientStream)
				 ]
			ensure: [ serverStream close ] ]
		ensure: [ clientStream close ]. ]
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> port [
	^ 1332
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> serverPriority [
	^ Processor lowIOPriority
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> serverSocket: aBlock [
	| serverSocket |
	[	serverSocket := self serverSocketOn: self port.
		self assert: serverSocket notNil.
		self assert: serverSocket localPort equals: self port.
		aBlock value: serverSocket]
	ensure: [ 
			serverSocket closeAndDestroy ]
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> serverSocketOn: port [
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

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> socketStreamTimeout [
	^ 30
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testAssertError [
	self should: [ self connectStreams: [ :serverStream :clientStream | 
			Error signal ] ] raise: Error.
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testBidirectionality [
	self connectStreams: [ :serverStream :clientStream |
		serverStream nextPut: 'Foo'.
		clientStream nextPut: true.
		self assert: serverStream next equals: true.
		self assert: clientStream next equals: 'Foo' ]
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testByteArray [
	self assertSerialize: #[ 1 23 54 ]
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testConnect [
	self connectStreams: [ :serverStream :clientStream | ]
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testDictionary [
	self assertSerialize: { #foo -> #(#err 4). 4 -> 16} asDictionary
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testInteger [
	self assertSerialize: 3
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testLargerString [
	self assertSerialize: 'pb6f6l7aqhz80ksi8i90e5iexer'
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testLargerStringRaw [
	self assertSerialize: 'pb6f6l7aqhz80ksi8i90e5iexer'
]

{ #category : #private }
LanguageLinkMsgPackSocketStreamTest >> testString [
	self assertSerialize: 'FooBarZork'
]
