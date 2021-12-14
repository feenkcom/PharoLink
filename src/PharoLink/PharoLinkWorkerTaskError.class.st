Class {
	#name : #PharoLinkWorkerTaskError,
	#superclass : #Error,
	#instVars : [
		'exception'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerTaskError class >> exception: anException [

	^ self new
		  initializeException: anException;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerTaskError class >> signalCausedBy: anException [

	^ (self exception: anException) signal
]

{ #category : #accessing }
PharoLinkWorkerTaskError >> exception [

	^ exception
]

{ #category : #accessing }
PharoLinkWorkerTaskError >> initializeException: anException [

	exception := anException
]
