Class {
	#name : #PharoLinkWorkerWaitTask,
	#superclass : #PharoLinkWorkerTask,
	#category : #'PharoLink-Examples'
}

{ #category : #accessing }
PharoLinkWorkerWaitTask >> leJsonV4Name [

	^ #pharoLinkWorkerWaitTask
]

{ #category : #accessing }
PharoLinkWorkerWaitTask >> run [

	Semaphore new wait
]
