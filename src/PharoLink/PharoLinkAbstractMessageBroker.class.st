"
The Message Broker is responsible for handling communications between the client and the server, and provides an abstraction to support multiple transport protocols, e.g. http and MsgPack.

Messages are either synchronous or asynchronous.  Messages that are synchronous are expected to have their answer in the http response.  Messages that are asynchronous will have their response sent back at a later time by the server in a separate http request from the server.
 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	messageCallbacks:		<Object>
	settings:		<Object>


    Implementation Points
"
Class {
	#name : #PharoLinkAbstractMessageBroker,
	#superclass : #Object,
	#instVars : [
		'messageCallbacks',
		'settings',
		'debugMode'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #accessing }
PharoLinkAbstractMessageBroker class >> methodArg [
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
	handler := LanguageLinkMessageHandler 
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
	^ settings serverSocketAddress port
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
PharoLinkAbstractMessageBroker >> setDebugMode [
	debugMode := true.
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
