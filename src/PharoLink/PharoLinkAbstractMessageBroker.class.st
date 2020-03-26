Class {
	#name : #PharoLinkAbstractMessageBroker,
	#superclass : #Object,
	#instVars : [
		'messageCallbacks',
		'settings'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #accessing }
PharoLinkAbstractMessageBroker class >> javaScriptMethodArg [
	self subclassResponsibility
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker class >> serializer [
	^ self serializerClass new
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker class >> serializerClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PharoLinkAbstractMessageBroker class >> settings: settings [
	^ self new
		settings: settings;
		yourself
]

{ #category : #messaging }
PharoLinkAbstractMessageBroker >> addCallback: aBlock messageClass: messageClass [
	messageCallbacks at: messageClass put: aBlock
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker >> debugMode [ 

	^ settings debugMode
]

{ #category : #private }
PharoLinkAbstractMessageBroker >> handle: dict reverseMessageClass: msgClass [
	| handler |
	(messageCallbacks includesKey: msgClass) ifFalse: [ LanguageLinkCommunicationError signal ].
	handler := JSLinkMessageHandler 
						forMessage: (msgClass decodeFrom: dict) 
						callback: (messageCallbacks at: msgClass).
	handler handleMessage.
	^ handler
]

{ #category : #initialization }
PharoLinkAbstractMessageBroker >> initialize [
	super initialize.
	messageCallbacks := Dictionary new.

]

{ #category : #testing }
PharoLinkAbstractMessageBroker >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker >> javaScriptUri [
	^ 'http://' , settings serverSocketAddress printAddress
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker >> port [
	^ settings clientSocketAddress port
]

{ #category : #private }
PharoLinkAbstractMessageBroker >> resolveMessageFromType: aType [
	^ LanguageLinkAbstractMessage allSubclasses 
			detect: [ :cls | cls type = aType ] 
			ifNone: [ Error signal: 'Message ' , aType , ' not understood.' ].
]

{ #category : #messaging }
PharoLinkAbstractMessageBroker >> sendAsyncMessage: aMessage [
	self subclassResponsibility
]

{ #category : #messaging }
PharoLinkAbstractMessageBroker >> sendMessage: aMessage [
	^ aMessage isSync
		ifTrue: [ self sendSyncMessage: aMessage ]
		ifFalse: [ self sendAsyncMessage: aMessage ]
]

{ #category : #messaging }
PharoLinkAbstractMessageBroker >> sendSyncMessage: aMessage [
	self subclassResponsibility
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker >> serializer [
	^ self class serializer
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker >> settings [
	^ settings
]

{ #category : #accessing }
PharoLinkAbstractMessageBroker >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
PharoLinkAbstractMessageBroker >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
PharoLinkAbstractMessageBroker >> stop [
	self subclassResponsibility
]
