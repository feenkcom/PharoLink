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

{ #category : #printing }
LanguageLinkSendCommandSignal >> printOn: stream [ 

	stream 
		nextPutAll: self timestamp asString;
		space;
		nextPutAll: self class name;
		space.
	command ifNil: [ ^stream << '<no command>' ].
	command blockString ifNil: [ ^stream << '<no source>' ].
	
	stream << command blockString.
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
