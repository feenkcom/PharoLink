"
JSLink currently only supports the HTTP message broker.

The MsgPack broker tests are disabled by making this a subclass of Object, instead of JSLinkMessageBrokerTest.

This should be moved back under JSLinkMessageBrokerTest when support for MsgPack is added.

"
Class {
	#name : #LanguageLinkMsgPackPharoBrokerTest,
	#superclass : #LanguageLinkMessageBrokerTest,
	#instVars : [
		'stubStream',
		'stubThread',
		'serverSocket'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #utils }
LanguageLinkMsgPackPharoBrokerTest >> answer [
	"MsgPack socket broker does not answer empty messages."
]

{ #category : #utils }
LanguageLinkMsgPackPharoBrokerTest >> answer: dict [
	self primSendMessageToBroker: dict
]

{ #category : #utils }
LanguageLinkMsgPackPharoBrokerTest >> assertCommunicationError: aBlock [
	"Message pack does not raise CommunicationError on exceptions at the other side"
]

{ #category : #running }
LanguageLinkMsgPackPharoBrokerTest >> buildAndStartStubServer [
	| bindSocket |

	serverSocket := LanguageLinkMsgPackUtils serverSocketOn: broker port.
	"Only listen for a single connection, then process it"
	stubThread := [ 
		[ bindSocket isNil ] whileTrue:
			[ bindSocket := serverSocket waitForAcceptFor: 10 ifTimedOut: [ nil ] ].
		stubStream := SocketStream on: bindSocket.
		stubStream := LanguageLinkMsgPackSocketStream on: stubStream.
		[ self stubPrimHandle: stubStream next ] repeat.
		 ] forkAt: Processor lowIOPriority.

]

{ #category : #utils }
LanguageLinkMsgPackPharoBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #hooks }
LanguageLinkMsgPackPharoBrokerTest >> messageBrokerClass [
	^ LanguageLinkMsgPackPharoBroker
]

{ #category : #private }
LanguageLinkMsgPackPharoBrokerTest >> primSendMessageToBroker: dict [
	stubStream nextPut: dict
]

{ #category : #hooks }
LanguageLinkMsgPackPharoBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerBlock: [ :ans | self assert: false ]
]

{ #category : #hooks }
LanguageLinkMsgPackPharoBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	self setHandler: aBlock.
	self primSendMessageToBroker: dict.
	self sleepAWhile.
]

{ #category : #utils }
LanguageLinkMsgPackPharoBrokerTest >> sleepAWhile [
	(Delay forMilliseconds: 150) wait.
]

{ #category : #running }
LanguageLinkMsgPackPharoBrokerTest >> stopStubServer [

	stubThread ifNotNil: [ stubThread terminate ].
	stubStream ifNotNil: [ stubStream close ].
	serverSocket ifNotNil: [ serverSocket closeAndDestroy ].

]

{ #category : #private }
LanguageLinkMsgPackPharoBrokerTest >> stubPrimHandle: msgDict [
	handlerBlock value: (msgDict at: #type) -> msgDict
]
