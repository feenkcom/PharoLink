Class {
	#name : #LanguageLinkSendCommandSignal,
	#superclass : #LanguageLinkCommandSignal,
	#instVars : [
		'commandFactory',
		'instructions',
		'bindingsDictionary'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkSendCommandSignal class >> eventType [
	^ LanguageLinkSendCommandEvent
]

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

{ #category : #testing }
LanguageLinkSendCommandSignal >> hasCommandString [
	^ self instructions notNil and: [ 
		self instructions notEmpty ]
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
