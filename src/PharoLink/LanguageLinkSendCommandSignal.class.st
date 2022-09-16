Class {
	#name : #LanguageLinkSendCommandSignal,
	#superclass : #LanguageLinkSignal,
	#instVars : [
		'command'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #logging }
LanguageLinkSendCommandSignal class >> emitCommand: aCommand [ 
	(self forCommand:  aCommand) emit
]

{ #category : #'instance creation' }
LanguageLinkSendCommandSignal class >> forCommand: aCommand [ 
	^ self new 
		command: aCommand
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> command [
	^ command
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> command: aCommand [ 
	command := aCommand
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> extractSelector [
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
LanguageLinkSendCommandSignal >> firstLineOf: aString [

	aString linesDo: [ :line | ^ line ]
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> gtViewCommandStringFor: aView [
	<gtView>
	
	self command ifNil: [
		^ aView empty ].
	
	^ aView forward
		title: 'Command String';
		object: [ self command ];
		view: #gtViewCodeForRemoteFor:
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> isSerializedCall [
	| targetInstruction|
	targetInstruction := self command instructions first.
	^ targetInstruction isString and: [
		targetInstruction includesSubstring: 'PharoLinkAnswerByValue setBySerialized.' ] 
]

{ #category : #printing }
LanguageLinkSendCommandSignal >> printOn: stream [ 

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
LanguageLinkSendCommandSignal >> printOneLineContentsOn: stream [ 
	| codeForRemote |
	codeForRemote := command codeForRemote.
	command ifNil: [ ^stream << '<no command>' ].
	codeForRemote ifNil: [ ^stream << '<no source>' ].
	
	stream
		<< (self firstLineOf: codeForRemote);
		<< '...'
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> remoteReceiverDescription [
	^ self command bindings 
		at: 'self' 
		ifPresent: [ :anObject | 
			
				'a '
				,anObject class remoteClassName
				, ' (' 
				, anObject name
				, ') ['
				, anObject identityHash asString
				, ']' ]
		ifAbsent: [nil]
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> remoteReceiverIdentityHash [
	^ self command bindings 
		at: 'self' 
		ifPresent: [ :anObject | anObject identityHash ]
		ifAbsent: [nil]
]
