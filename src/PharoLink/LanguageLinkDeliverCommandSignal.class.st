Class {
	#name : #LanguageLinkDeliverCommandSignal,
	#superclass : #LanguageLinkCommandSignal,
	#instVars : [
		'command'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #logging }
LanguageLinkDeliverCommandSignal class >> emitEndForCommand: aCommand [ 
	(self forCommand:  aCommand) 
		markAsEndSignal;
		emit
]

{ #category : #logging }
LanguageLinkDeliverCommandSignal class >> emitStartForCommand: aCommand [ 
	(self forCommand:  aCommand) emit
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal class >> eventType [
	^ LanguageLinkDeliverCommandEvent
]

{ #category : #'instance creation' }
LanguageLinkDeliverCommandSignal class >> forCommand: aCommand [ 
	^ self new 
		command: aCommand
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal >> bindingsDictionary [

	^ self command bindings
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal >> command [
	^ command
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal >> command: aCommand [ 
	command := aCommand
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal >> commandString [
	^ self command codeForRemote
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal >> extractSelector [
	| targetInstruction instructionCode|
	targetInstruction := self command instructions last.
	instructionCode := targetInstruction sourceCode.
	(instructionCode beginsWith: 'llCommand') ifFalse: [ ^ '-'].
	
	^ ((instructionCode 
		copyFrom: (instructionCode findString: 'notify:') + 7
		to: (instructionCode findString: 'id:') -1) trimBoth
			removePrefix: '(')
			removeSuffix: ')'
]

{ #category : #utils }
LanguageLinkDeliverCommandSignal >> firstLineOf: aString [

	aString linesDo: [ :line | ^ line ]
]

{ #category : #testing }
LanguageLinkDeliverCommandSignal >> hasCommandString [
	^ self command instructions notNil and: [ 
		self command instructions notEmpty ]
]

{ #category : #initialization }
LanguageLinkDeliverCommandSignal >> initialize [
	super initialize.
	
	self markAsStartSignal.
]

{ #category : #accessing }
LanguageLinkDeliverCommandSignal >> isSerializedCall [
	| targetInstruction |
	targetInstruction := self command instructions first.
	^ targetInstruction isString and: [
		targetInstruction includesSubstring: 'PharoLinkAnswerByValue setBySerialized.' ] 
]

{ #category : #printing }
LanguageLinkDeliverCommandSignal >> printOn: stream [ 

	stream 
		nextPutAll: self timestamp asString;
		space;
		nextPutAll: self class name;
		space.
	command ifNil: [ ^stream << '<no command>' ].
	command codeForRemote 
		ifNil: [ ^stream << '<no source>' ]
		ifNotNil: [ :aString |
			stream << aString ]
	
]

{ #category : #printing }
LanguageLinkDeliverCommandSignal >> printOneLineContentsOn: stream [ 
	| codeForRemote |
	codeForRemote := command codeForRemote.
	command ifNil: [ ^stream << '<no command>' ].
	codeForRemote ifNil: [ ^stream << '<no source>' ].
	
	stream
		<< (self firstLineOf: codeForRemote);
		<< '...'
]
