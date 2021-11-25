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
PharoLinkWorkerScheduler >> taskDone: aTask with: anObject [

	| promise |
	Halt once.
	self flag: 'TODO fulfill should probably fork, as called in callback'.
	promisesMonitor critical: [ promise := promises removeKey: aTask id ].
	promise fulfillWithValue: anObject
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskFailed: aTask with: anObject [

	| promise |
	Halt once.
	self flag: 'TODO fulfill should probably fork, as called in callback'.
	promisesMonitor critical: [ promise := promises removeKey: aTask id ].
	promise rejectWithError: anObject
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskPoll [

	^ queue next
]

{ #category : #accessing }
PharoLinkWorkerScheduler >> taskSubmit: aTask [

	| promise |
	promise := AsyncPendingPromise new.
	queue nextPut: aTask.
	promisesMonitor critical: [ promises at: aTask id put: promise ].
	^ promise
]
