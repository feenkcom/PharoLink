"
This class contains tests

"
Class {
	#name : #LanguageLinkMessageBrokerTest,
	#superclass : #TestCase,
	#instVars : [
		'broker',
		'handlerBlock',
		'handlerException',
		'settings'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #testing }
LanguageLinkMessageBrokerTest class >> isAbstract [
	^ self == LanguageLinkMessageBrokerTest
]

{ #category : #accessing }
LanguageLinkMessageBrokerTest >> answer: aDictionary [
	self subclassResponsibility
]

{ #category : #utils }
LanguageLinkMessageBrokerTest >> assertCommunicationError: aBlock [
	self should: aBlock raise: LanguageLinkCommunicationError
]

{ #category : #accessing }
LanguageLinkMessageBrokerTest >> brokerUri [
	^ 'http://' , settings clientSocketAddress printAddress
]

{ #category : #initialization }
LanguageLinkMessageBrokerTest >> buildAndStartStubServer [
	self subclassResponsibility
]

{ #category : #running }
LanguageLinkMessageBrokerTest >> defaultSettings [
	^ LanguageLinkSettings pharoDefaultSettings

]

{ #category : #utils }
LanguageLinkMessageBrokerTest >> errorResponse [
]

{ #category : #hooks }
LanguageLinkMessageBrokerTest >> for: messageClass setCallback: aBlock [
	^ broker addCallback: aBlock messageClass: messageClass
]

{ #category : #initialization }
LanguageLinkMessageBrokerTest >> initialize [
	super initialize.
	handlerBlock := [ :r |  ]
]

{ #category : #accessing }
LanguageLinkMessageBrokerTest >> javaScriptUri [
	^ 'http://' , settings serverSocketAddress printAddress
]

{ #category : #hooks }
LanguageLinkMessageBrokerTest >> messageBrokerClass [
	self subclassResponsibility
]

{ #category : #utils }
LanguageLinkMessageBrokerTest >> sendMessageToBroker: dict [
	self subclassResponsibility
]

{ #category : #utils }
LanguageLinkMessageBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	self subclassResponsibility
]

{ #category : #utils }
LanguageLinkMessageBrokerTest >> sendMessageToBroker: dict answerEquals: ansDict [
	| flag |
	flag := false.
	self sendMessageToBroker: dict answerBlock: [ :aDict | 
		flag := true.
		self assert: aDict equals: ansDict ].
	self assert: flag
]

{ #category : #accessing }
LanguageLinkMessageBrokerTest >> setHandler: aBlock [
	handlerBlock := aBlock
]

{ #category : #running }
LanguageLinkMessageBrokerTest >> setUp [
	super setUp.
	settings := self defaultSettings.
	broker := self messageBrokerClass settings: settings.
	self buildAndStartStubServer.
	broker start.
	self sleepAWhile
]

{ #category : #utils }
LanguageLinkMessageBrokerTest >> sleepAWhile [
	"Sleeping for a while so the async message has a chance to perform a change."
	self subclassResponsibility
]

{ #category : #running }
LanguageLinkMessageBrokerTest >> stopStubServer [
	self subclassResponsibility 
]

{ #category : #running }
LanguageLinkMessageBrokerTest >> tearDown [
	broker ifNotNil: [ broker stop ].
	self stopStubServer
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testEnqueueCommandMessage [
	| flag msg |
	flag := false.
	msg := LanguageLinkEnqueueCommandMessage 
				commandId: '7365'
				statements: 'foo().cat()'
				bindings: { #foo -> 42 . #bar -> 'zork' } asDictionary.
	self setHandler: [ :assoc | | bindings |
		self assert: assoc key equals: LanguageLinkEnqueueCommandMessage type.
		self assert: assoc value size equals: 4.
		self assert: (assoc value at: 'type') equals: LanguageLinkEnqueueCommandMessage type.
		self assert: (assoc value at: 'commandId') equals: '7365'.
		self assert: (assoc value at: 'statements') equals: 'foo().cat()'.
		bindings := assoc value at: 'bindings'.
		self assert: bindings size equals: 2.
		self assert: (bindings at: 'foo') equals: 42.
		self assert: (bindings at: 'bar') equals: 'zork'.
		flag := true ].
	broker sendMessage: msg.
	self sleepAWhile.
	self assert: flag
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testErrorOnCallback [
	| flag |
	flag := false.
	self for: LanguageLinkRSyncMessage setCallback: [ :msg |
		Error signal.
		flag := true ].
	self assertCommunicationError: [ 
			self 
				sendMessageToBroker: { 
					#type -> LanguageLinkRSyncMessage type.
					#__sync -> 'foobar' } asDictionary
				answerBlock: [  ] ].
	self deny: flag
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testEvalAnswer [
	| flag |
	flag := false.
	self for: LanguageLinkUpdatePromiseMessage setCallback: [ :msg |
		self assert: msg type equals: LanguageLinkUpdatePromiseMessage type.
		self assert: msg value equals: 'foobar'.
		self assert: msg promiseId equals: '4fcb36d'.
		flag := true ].
	self sendMessageToBroker: { 
				#type -> LanguageLinkUpdatePromiseMessage type.
				#id -> '4fcb36d'.
				#value -> 'foobar' } asDictionary.
	self assert: flag
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testIsAliveMessage [
	| flag msg |
	flag := false.
	self setHandler: [ :assoc |
		self assert: assoc key equals: LanguageLinkIsAliveMessage type.
		self assert: assoc value associations size equals: 2.
		self assert: (assoc value at: #type) equals: LanguageLinkIsAliveMessage type.
		self assert: (assoc value at: #__sync) equals: msg syncId.
		flag := true.
		self answer: { #type -> LanguageLinkIsAliveMessage type. #__sync -> msg syncId } asDictionary ].
	msg := LanguageLinkIsAliveMessage new.
	broker sendMessage: msg.
	self assert: flag
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testIsRunning [
	self assert: broker isRunning
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testRMessageWithParams [
	| flag |

	self skip: 'MsgPack not yet working'.
	flag := false.
	self for: LanguageLinkCallbackMessage setCallback: [ :msg |
		flag := true.
		self assert: msg type equals: LanguageLinkCallbackMessage type.
		self assert: msg commandId equals: 10.
		self assert: msg observerId equals: 'foo'.
		self assert: msg value equals: 'lalala'.
		self assert: msg syncId equals: 'zork'.
		msg createAnswer
			value: 13;
			yourself ].
	self 
		sendMessageToBroker: { 
			#type -> LanguageLinkCallbackMessage type.
			#commandId -> 10.
			#observerId -> 'foo'.
			#value -> 'lalala'.
			#__sync -> 'zork' } asDictionary
		answerEquals: { 
			#type -> LanguageLinkCallbackMessage type.
			#value -> 13.
			#__sync -> 'zork' } asDictionary.
	self assert: flag.
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testRSyncMessage [
	| flag |

	self skip: 'MsgPack not yet working'.
	flag := false.
	self for: LanguageLinkRSyncMessage setCallback: [ :msg |
		flag := true.
		msg createAnswer ].
	self 
		sendMessageToBroker: { 
			#type -> LanguageLinkRSyncMessage type.
			#__sync -> 'foobar' } asDictionary
		answerEquals: { 
			#type -> LanguageLinkRSyncMessage type.
			#__sync -> 'foobar' } asDictionary.
	self assert: flag.
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testSyncMessage [
	| flag msg ans |
	flag := false.
	self setHandler: [ :assoc |
		self assert: assoc key equals: LanguageLinkSyncMessage type.
		self assert: assoc value associations size equals: 2.
		self assert: (assoc value at: #type) equals: LanguageLinkSyncMessage type.
		self assert: (assoc value at: #__sync) equals: msg syncId.
		flag := true.
		self answer: { #type -> LanguageLinkSyncMessage type . #__sync -> msg syncId } asDictionary ].
	msg := LanguageLinkSyncMessage new.
	ans := broker sendMessage: msg.
	self assert: ans message equals: msg.
	self assert: flag
]

{ #category : #tests }
LanguageLinkMessageBrokerTest >> testWrongRouteAnswer [
	| flag |
	flag := false.
	self for: LanguageLinkCallbackMessage setCallback: [ :dict |
		flag := true ].
	self assertCommunicationError:  [ self sendMessageToBroker: { 
								#type -> LanguageLinkRSyncMessage type.
								#__sync -> 'foobar' } asDictionary ].
	self deny: flag
]
