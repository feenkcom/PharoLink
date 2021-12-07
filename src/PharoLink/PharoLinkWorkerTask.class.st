Class {
	#name : #PharoLinkWorkerTask,
	#superclass : #Object,
	#instVars : [
		'id',
		'results'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerTask class >> leJsonV4Name [

	^ #pharoLinkWorkerTask
]

{ #category : #accessing }
PharoLinkWorkerTask >> id [

	^ id
]

{ #category : #accessing }
PharoLinkWorkerTask >> id: aString [

	id := aString
]

{ #category : #accessing }
PharoLinkWorkerTask >> initialize [

	super initialize.
	id := 'plw' , UUID new asString36
]

{ #category : #copying }
PharoLinkWorkerTask >> postCopy [

	super postCopy.
	id := 'plw' , UUID new asString36.
]

{ #category : #accessing }
PharoLinkWorkerTask >> results [

	^ results
]

{ #category : #accessing }
PharoLinkWorkerTask >> results: anObject [

	results := anObject
]

{ #category : #accessing }
PharoLinkWorkerTask >> run [

	self subclassResponsibility
]
