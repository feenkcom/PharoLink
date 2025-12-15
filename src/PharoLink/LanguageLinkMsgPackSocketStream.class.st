Class {
	#name : #LanguageLinkMsgPackSocketStream,
	#superclass : #Object,
	#instVars : [
		'socketStream',
		'encoder',
		'decoder',
		'decoderSemaphore',
		'encoderSemaphore'
	],
	#category : #'PharoLink-MessageBroker'
}

{ #category : #'instance creation' }
LanguageLinkMsgPackSocketStream class >> on: socketStream [
	^ self new
		on: socketStream;
		yourself
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> atEnd [
	^ decoderSemaphore critical: [ decoder atEnd ]
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> close [
	| ans |
	ans := socketStream socket ifNotNil: #closeAndDestroy.
	30 timesRepeat: [ encoderSemaphore signal ].
	30 timesRepeat: [ decoderSemaphore signal ].
	^ ans
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> flush [
	^ socketStream flush
]

{ #category : #initialization }
LanguageLinkMsgPackSocketStream >> initialize [
	super initialize.
	decoderSemaphore := Semaphore forMutualExclusion.
	encoderSemaphore := Semaphore forMutualExclusion.
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> isConnected [
	^ socketStream isConnected
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> isStream [
	^true
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> next [
	^ decoderSemaphore critical: [ decoder next ]
]

{ #category : #streaming }
LanguageLinkMsgPackSocketStream >> nextPut: anObject [
	| result |
	result := encoderSemaphore critical: [ 
		encoder nextPut: anObject.
		socketStream flush ].
	^ result
]

{ #category : #'instance creation' }
LanguageLinkMsgPackSocketStream >> on: aSocketStream [
	socketStream := aSocketStream.
	self setSocketStreamOptions: socketStream.
	encoder := MpEncoder on: socketStream.
	decoder := MpDecoder on: socketStream
]

{ #category : #private }
LanguageLinkMsgPackSocketStream >> setSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self socketBufferSize;
		noTimeout
]

{ #category : #private }
LanguageLinkMsgPackSocketStream >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
LanguageLinkMsgPackSocketStream >> socketStreamTimeout [
	^ 30
]
