Class {
	#name : #LanguageLinkSendCommandSignal,
	#superclass : #LanguageLinkSignal,
	#instVars : [
		'commandFactory',
		'instructions',
		'bindingsDictionary'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #'instance creation' }
LanguageLinkSendCommandSignal class >> forCommandFactory: aCommandFactory [ 
	^ self new 
		commandFactory: aCommandFactory
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> bindingsDictionary [

	^ bindingsDictionary
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> bindingsDictionary: anObject [

	bindingsDictionary := anObject
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> commandFactory [

	^ commandFactory
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> commandFactory: anObject [

	commandFactory := anObject
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> commandString [
	^ String streamContents:  [ :aStream | 
		self instructions 
			asStringOn: aStream 
			delimiter: String cr ]
]

{ #category : #'gt - extensions' }
LanguageLinkSendCommandSignal >> gtViewBindingsFor: aView [
	<gtView>
	
	self bindingsDictionary ifNil: [
		^ aView empty ].
	
	^ aView forward
		title: 'Bindings';
		priority: 25;
		object: [ self bindingsDictionary ];
		view: #gtItemsFor:
]

{ #category : #'gt - extensions' }
LanguageLinkSendCommandSignal >> gtViewCommandStringFor: aView [
	<gtView>
	
	self instructions ifNil: [
		^ aView empty ].
	
	^ aView textEditor
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new
				   isForWorkspace: true;
				   yourself);
		title: 'Command String' translated;
		text: [ self commandString ];
		priority: 14
]

{ #category : #'gt - extensions' }
LanguageLinkSendCommandSignal >> gtViewInstructionsFor: aView [
	<gtView>
	
	self instructions ifNil: [
		^ aView empty ].
	
	^ aView forward
		title: 'Instructions';
		priority: 20;
		object: [ self instructions ];
		view: #gtItemsFor:
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> instructions [

	^ instructions
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> instructions: anObject [

	instructions := anObject
]

{ #category : #printing }
LanguageLinkSendCommandSignal >> printOneLineContentsOn: aStream [ 
	instructions ifNil: [ ^aStream << '<no instructions>' ].
	instructions ifEmpty: [ ^aStream << '<no instructions>' ].
	
	aStream << instructions first.
	instructions size > 1 ifTrue: [
		aStream << '...' ]
]

{ #category : #accessing }
LanguageLinkSendCommandSignal >> remoteReceiverDescription [
	^ self bindingsDictionary
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
	^ self bindingsDictionary 
		at: 'self' 
		ifPresent: [ :anObject | anObject identityHash ]
		ifAbsent: [nil]
]
