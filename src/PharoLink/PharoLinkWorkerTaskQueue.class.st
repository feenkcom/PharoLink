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
PharoLinkWorkerTaskQueue >> taskDone: aTaskId with: anObject [

	| promise |
	self flag: 'TODO fulfill should probably fork, as called in callback'.
	promisesMonitor critical: [ promise := promises removeKey: aTaskId ].
	promise fulfillWithValue: anObject
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> taskFailed: aTaskId with: anObject [

	| promise |
	self flag: 'TODO fulfill should probably fork, as called in callback'.
	promisesMonitor critical: [ promise := promises removeKey: aTaskId ].
	promise rejectWithError: anObject
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> taskPoll [

	^ queue next
]

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> taskSubmit: aTask [

	| promise |
	promise := AsyncPendingPromise new.
	queue nextPut: aTask.
	promisesMonitor critical: [ promises at: aTask id put: promise ].
	^ promise
]
