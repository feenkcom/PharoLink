Class {
	#name : 'LanguageLinkHandler',
	#superclass : 'Object',
	#instVars : [
		'application'
	],
	#category : 'PharoLink-Core'
}

{ #category : 'as yet unclassified' }
LanguageLinkHandler class >> application: anApplication [
	^ self new
		application: anApplication;
		initializeHandler;
		yourself
]

{ #category : 'accessing' }
LanguageLinkHandler >> application [
	^ application
]

{ #category : 'accessing' }
LanguageLinkHandler >> application: anObject [
	application := anObject
]

{ #category : 'accessing' }
LanguageLinkHandler >> debugMode [ 

	^ application debugMode
]

{ #category : 'initialization' }
LanguageLinkHandler >> initializeHandler [
]

{ #category : 'testing' }
LanguageLinkHandler >> isRunning [
	^ true
]

{ #category : 'accessing' }
LanguageLinkHandler >> settings [ 

	^ self application settings
]

{ #category : 'accessing' }
LanguageLinkHandler >> start [
]

{ #category : 'accessing' }
LanguageLinkHandler >> stop [
]
