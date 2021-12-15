Class {
	#name : #PharoLinkWorkerTask,
	#superclass : #Object,
	#instVars : [
		'id',
		'result'
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

{ #category : #accessing }
PharoLinkWorkerTask >> result [

	^ result
]

{ #category : #accessing }
PharoLinkWorkerTask >> result: anObject [

	result := anObject
]

{ #category : #accessing }
PharoLinkWorkerTask >> run [

	self subclassResponsibility
]

{ #category : #accessing }
PharoLinkWorkerTask >> value [

	^ [ self run ]
		  on: Exception
		  do: [ :exception | 
		  PharoLinkWorkerTaskError signalCausedBy: exception ]
]
