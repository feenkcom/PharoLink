Class {
	#name : #PharoLinkWorkerTaskQueue,
	#superclass : #Object,
	#instVars : [
		'queue',
		'promises',
		'promisesMonitor'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> initialize [

	super initialize.
	queue := SharedQueue new.
	promises := Dictionary new.
	promisesMonitor := Monitor new
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> next [

	^ queue next
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> nextPut: aTask [

	| promise |
	promise := AsyncPendingPromise new.
	queue nextPut: aTask.
	promisesMonitor critical: [ promises at: aTask id put: promise ].
	^ promise
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> notifyDone: aTaskId with: anObject [

	| promise |
	promisesMonitor critical: [ promise := promises removeKey: aTaskId ].
	promise fulfillWithValue: anObject
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> notifyFailed: aTaskId with: anObject [

	| promise |
	promisesMonitor critical: [ promise := promises removeKey: aTaskId ].
	promise rejectWithError: anObject
]
