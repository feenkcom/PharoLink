Class {
	#name : #LanguageLinkProxyObject,
	#superclass : #Object,
	#traits : 'TGtPharoLinkPlayground',
	#classTraits : 'TGtPharoLinkPlayground classTrait',
	#instVars : [
		'application',
		'remoteClass',
		'name'
	],
	#category : #'PharoLink-Core'
}

{ #category : #accessing }
LanguageLinkProxyObject class >> leProxyTypeForPlaygroundPage [
	^ LanguageLinkProxyObject
]

{ #category : #'instance creation' }
LanguageLinkProxyObject class >> remoteClass: remoteClassName name: registryId 	application: aLLApplication [

	^ self new
		remoteClass: remoteClassName;
		name: registryId;
		application: aLLApplication
]

{ #category : #comparing }
LanguageLinkProxyObject >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ remoteClass = anObject remoteClass
		and: [ application = anObject application
				and: [ name = anObject name ] ]
]

{ #category : #initialize }
LanguageLinkProxyObject >> actOnProxyObjectCreated [
	"Callback that subclasses can use to automatically perform actions after the proxy object is created.
	There should be no calls here that perform remote calls. It leads to deadlocks."
]

{ #category : #accessing }
LanguageLinkProxyObject >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkProxyObject >> application: anObject [
	application := anObject
]

{ #category : #evaluating }
LanguageLinkProxyObject >> evaluateAndWait: aString [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		<< aString;
		sendAndWait.

]

{ #category : #comparing }
LanguageLinkProxyObject >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ remoteClass hash bitXor: (application hash bitXor: name hash)
]

{ #category : #initialize }
LanguageLinkProxyObject >> initalizeWithRemoteClass: aRemoteClassName name: aRegistryId application: anApplication [
	self 
		remoteClass: aRemoteClassName;
		name: aRegistryId;
		application: anApplication.
	self actOnProxyObjectCreated.
]

{ #category : #testing }
LanguageLinkProxyObject >> isLanguageLinkProxyObject [
	"Answer a boolean indicating whether the receiver is a LanuageLink proxy object."
	
	^ true
]

{ #category : #testing }
LanguageLinkProxyObject >> isProxyObjectActive [
	^ application 
		ifNil: [ false ] 
		ifNotNil: [ :anApplication | 
			anApplication isRunning ] 
]

{ #category : #accessing }
LanguageLinkProxyObject >> name [
	^ name
]

{ #category : #accessing }
LanguageLinkProxyObject >> name: anObject [
	name := anObject
]

{ #category : #serialization }
LanguageLinkProxyObject >> neoJsonOn: aWriter [

	{ '__class__' -> remoteClass.
	'__registryid__' -> name. } asDictionary
		neoJsonOn: aWriter
]

{ #category : #'instance creation' }
LanguageLinkProxyObject >> newCommandFactory [
	| cf |

	cf := self application newCommandFactory.
	self addPlaygroundBindingsTo: cf.
	^ cf
]

{ #category : #accessing }
LanguageLinkProxyObject >> pharoLinkFormattedCode [ 

	^ 'llCommand registry resolve: ', name printString
]

{ #category : #printing }
LanguageLinkProxyObject >> printOn: str [
	str 
		<< (remoteClass asString first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		<< remoteClass asString;
		<< ' (';
		<< self class name;
		<< ')'
]

{ #category : #accessing }
LanguageLinkProxyObject >> proxyObjectId [ 

	^ name
]

{ #category : #evaluating }
LanguageLinkProxyObject >> proxyPerform: aSymbol [

	^ self evaluateAndWait: 'self ', aSymbol
]

{ #category : #evaluating }
LanguageLinkProxyObject >> proxyPerform: aSymbol withCopiedArguments: anArrayOfArguments [

	"Copied arguments by serializing with Fuel. Does not serialize the result."

	| message |
	message := String streamContents: [ :stream | 
		           stream nextPutAll: '
						arguments := LanguageLinkUtils base64Decode: '''.
		           LanguageLinkUtils
			           base64Encode: anArrayOfArguments
			           to: stream.
		           stream nextPutAll: ''' readStream.
						self perform: '.
		           aSymbol printOn: stream.
		           stream nextPutAll: ' withArguments: arguments' ].
	^ self evaluateSourceSequence: message
]

{ #category : #evaluating }
LanguageLinkProxyObject >> proxyPerform: aSymbol withCopiedResultAndArguments: anArrayOfArguments [

	"Copied arguments by serializing with Fuel. Does not serialize the result."

	| message result |
	message := String streamContents: [ :stream | 
		           stream nextPutAll: '
						arguments := LanguageLinkUtils base64Decode: '''.
		           LanguageLinkUtils
			           base64Encode: anArrayOfArguments
			           to: stream.
		           stream nextPutAll: ''' readStream.
						result := self perform: '.
		           aSymbol printOn: stream.
		           stream nextPutAll: ' withArguments: arguments.
		           	 message := String streamContents: [ :stream |
							LanguageLinkUtils base64Encode: result to: stream ].
						message' ].
	result := self evaluateSourceSequence: message.
	^ LanguageLinkUtils base64Decode: result readStream
]

{ #category : #'message performing' }
LanguageLinkProxyObject >> proxyPerform: aSymbol withPrimitiveArguments: anArrayOfArguments [
	"Evaluate the supplied selector on the remote with the given arguments"

	aSymbol isUnary ifTrue:
		[ anArrayOfArguments
			ifEmpty: [ ^ self proxyPerform: aSymbol ]
			ifNotEmpty: [ self error: 'Unary selector with arguments' ] ].

	self assert: anArrayOfArguments isArray.
	self assert: anArrayOfArguments canBePharoLinkPrimitive.

	self assert: (aSymbol findTokens: $:) size = anArrayOfArguments size.

	^ self newCommandFactory
		bindingAt: #argArray put: anArrayOfArguments;
		<< ('self perform: #', aSymbol, ' withArguments: argArray');
		sendAndWait.
]

{ #category : #evaluating }
LanguageLinkProxyObject >> proxyPerformByValue: aSymbol [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		setByValue;
		<< ('self ', aSymbol);
		sendAndWait.
]

{ #category : #evaluating }
LanguageLinkProxyObject >> proxyPerformSerialized: aSymbol [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		setBySerialized;
		<< ('self ', aSymbol);
		sendAndWait
]

{ #category : #evaluating }
LanguageLinkProxyObject >> proxyPerformSerialized: aSymbol withPrimitiveArguments: anArrayOfArguments [
	| cf |

	aSymbol isUnary ifTrue:
		[ anArrayOfArguments
			ifEmpty: [ ^ self proxyPerformSerialized: aSymbol ]
			ifNotEmpty: [ self error: 'Unary selector with arguments' ] ].

	self assert: anArrayOfArguments isArray.
	self assert: anArrayOfArguments canBePharoLinkPrimitive.

	cf := self newCommandFactory.
	^ cf
		bindingAt: #argArray put: anArrayOfArguments; 
		setBySerialized;
		<< ('self perform: #', aSymbol, ' withArguments: argArray');
		sendAndWait
]

{ #category : #accessing }
LanguageLinkProxyObject >> remoteClass [
	^ remoteClass
]

{ #category : #accessing }
LanguageLinkProxyObject >> remoteClass: anObject [
	remoteClass := anObject
]

{ #category : #accessing }
LanguageLinkProxyObject >> settings [ 

	^ application settings
]
