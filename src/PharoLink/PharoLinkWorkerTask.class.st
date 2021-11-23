Class {
	#name : #PharoLinkWorkerTask,
	#superclass : #Object,
	#instVars : [
		'source',
		'id'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerTask class >> source: anotherString [

	^ self new
		  initializeSource: anotherString;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerTask >> asDictionary [

	^ { 
		  (#id -> id).
		  (#source -> source) } asDictionary
]

{ #category : #accessing }
PharoLinkWorkerTask >> initializeSource: anotherString [

	id := 'plw' , UUID new asString36.
	source := anotherString
]
