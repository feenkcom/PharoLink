Class {
	#name : #PharoLinkWorkerTaskQueue,
	#superclass : #Object,
	#instVars : [
		'queue',
		'promises',
		'promisesMonitor',
		'observers',
		'observerSemaphores'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerTaskQueue >> initialize [

	super initialize.
	observers := Dictionary new.
	observerSemaphores := Dictionary new.
	queue := SharedQueue new.
	promises := Dictionary new.
	promisesMonitor := Monitor new
]

{ #category : #notifying }
PharoLinkWorkerTaskQueue >> ping: aString [

	^ (observers at: aString) value: #Ping
]

{ #category : #observer }
PharoLinkWorkerTaskQueue >> registerObserver: aString with: aBlock [

	"Waits until semaphore of observer is signalled to keep request alive, as observers live in the request-response life-cycle."

	| semaphore |
	semaphore := Semaphore new.
	observers at: aString put: aBlock.
	observerSemaphores at: aString put: semaphore.
	semaphore wait.
	^ true
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

{ #category : #observer }
PharoLinkWorkerTaskQueue >> unregisterObserver: aString [

	(observerSemaphores at: aString) signal.
	observers removeKey: aString.
	observerSemaphores removeKey: aString.
	^ true
]
