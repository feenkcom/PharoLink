Class {
	#name : #PharoLinkWorkerServer,
	#superclass : #PharoLinkServer,
	#instVars : [
		'taskQueue'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerServer >> initialize [

	super initialize.
	self scheduler: PharoLinkWorkerTaskQueue new
]

{ #category : #'form-scripting' }
PharoLinkWorkerServer >> submit: aTask [

	^ taskQueue taskSubmit: aTask
]

{ #category : #accessing }
PharoLinkWorkerServer >> taskQueue [

	^ taskQueue
]

{ #category : #accessing }
PharoLinkWorkerServer >> taskQueue: aPharoLinkWorkerTaskQueue [

	taskQueue := aPharoLinkWorkerTaskQueue.
	globals at: #taskQueue put: taskQueue
]
