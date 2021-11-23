Class {
	#name : #PharoLinkWorkerScheduler,
	#superclass : #Object,
	#instVars : [
		'queue',
		'promises',
		'promisesMonitor'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerScheduler >> initialize [

	super initialize.
	queue := SharedQueue new.
	promises := Dictionary new.
	promisesMonitor := Monitor new
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskDone: aTaskId with: anObject [

	| promise |
	self flag: 'TODO fulfill should probably fork, as called in callback'.
	promisesMonitor critical: [ promise := promises removeKey: aTaskId ].
	promise fulfillWithValue: anObject
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskFailed: aTaskId with: anObject [

	| promise |
	self flag: 'TODO fulfill should probably fork, as called in callback'.
	promisesMonitor critical: [ promise := promises removeKey: aTaskId ].
	promise rejectWithError: anObject
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskPoll [

	^ queue next asDictionary
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskSubmit: aTask [

	| promise |
	promise := AsyncPendingPromise new.
	queue add: aTask.
	promisesMonitor critical: [ promises at: aTask id put: promise ].
	^ promise
]
