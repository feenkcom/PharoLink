Class {
	#name : #LanguageLinkHandler,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#category : 'PharoLink-Core'
}

{ #category : #initalization }
LanguageLinkHandler class >> application: anApplication [
	^ self new
		application: anApplication;
		initializeHandler;
		yourself
]

{ #category : #accessing }
LanguageLinkHandler >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkHandler >> application: anObject [
	application := anObject
]

{ #category : #accessing }
LanguageLinkHandler >> debugMode [ 

	^ application debugMode
]

{ #category : #'gt extensions' }
LanguageLinkHandler >> gtDetails [
	^ { 
		{ #application . application }.
		{ #running . self isRunning }
	}
]

{ #category : #'gt extensions' }
LanguageLinkHandler >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		priority: 20;
		items: [ self gtDetails ];
		column: 'Key' text: #first weight: 0.5;
		column: 'Value' text: #second;
		send: #last
]

{ #category : #initialization }
LanguageLinkHandler >> initializeHandler [
]

{ #category : #testing }
LanguageLinkHandler >> isRunning [
	^ true
]

{ #category : #accessing }
LanguageLinkHandler >> settings [ 

	^ self application settings
]

{ #category : #'start-stop' }
LanguageLinkHandler >> start [
]

{ #category : #'start-stop' }
LanguageLinkHandler >> stop [
]
