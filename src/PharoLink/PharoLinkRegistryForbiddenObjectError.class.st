Class {
	#name : #PharoLinkRegistryForbiddenObjectError,
	#superclass : #PharoLinkRegistryError,
	#instVars : [
		'object'
	],
	#category : 'PharoLink-Registry'
}

{ #category : #signalling }
PharoLinkRegistryForbiddenObjectError class >> signalOject: anObject [

	^ self new 
		object: anObject;
		messageText: ('Attempt to register forbidden object: {1}' format:
			{ anObject. });
		signal.
]

{ #category : #accessing }
PharoLinkRegistryForbiddenObjectError >> object [
	^ object
]

{ #category : #accessing }
PharoLinkRegistryForbiddenObjectError >> object: anObject [
	object := anObject
]
