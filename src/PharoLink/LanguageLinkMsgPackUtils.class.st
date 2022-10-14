"
LanguageLinkMsgPackUtils provides common configuration for the {{gtClass:Socket}} and {{gtClass:SocketStream}} used to communicate between the clients and servers.
"
Class {
	#name : #LanguageLinkMsgPackUtils,
	#superclass : #Object,
	#category : #'PharoLink-MessageBroker'
}

{ #category : #constants }
LanguageLinkMsgPackUtils class >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 1024
]

{ #category : #'socket creation' }
LanguageLinkMsgPackUtils class >> openConnectionToHost: address port: port [
	| stream |
	stream := SocketStream openConnectionToHost: address port: port.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #'socket creation' }
LanguageLinkMsgPackUtils class >> primStreamFromSocket: aSocket [
	| stream |
	stream := SocketStream on: aSocket.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #'socket creation' }
LanguageLinkMsgPackUtils class >> serverSocketOn: port [
	"Answer a configured socket listening on port"
	| socket |

	(socket := Socket newTCP)
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: self socketBufferSize;
		setOption: 'SO_RCVBUF' value: self socketBufferSize .
	socket listenOn: port backlogSize: self listenBacklogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : #private }
LanguageLinkMsgPackUtils class >> setReferenceSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: true;
		bufferSize: LanguageLinkMsgPackUtils socketBufferSize;
		noTimeout
]

{ #category : #constants }
LanguageLinkMsgPackUtils class >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]
