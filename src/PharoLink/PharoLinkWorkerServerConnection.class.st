Class {
	#name : #PharoLinkWorkerServerConnection,
	#superclass : #PharoLinkServerConnection,
	#instVars : [
		'observer',
		'lastPing',
		'observerProcess'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerServerConnection >> addObserver: aBlock [

	"Waits until semaphore of observer is signalled to keep request alive, as observers live in the request-response life-cycle."

	self assert: [ observer isNil ].
	self assert: [ observerProcess isNil ].
	observer := aBlock.
	observerProcess := Processor activeProcess.
	Semaphore new wait.
	^ true
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> cancelCurrentTask [

	^ observer value: #CancelCurrentTask
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> globals [

	^ super globals copy
		  at: #connection put: self;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> hasObserver [

	^ observer isNotNil
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> lastPing [

	^ lastPing
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> notifyPing [

	lastPing := DateAndTime now
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> ping [

	^ observer value: #Ping
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> quitSmalltalk [

	^ observer value: #QuitSmalltalk
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> removeObserver [

	observerProcess terminate.
	observerProcess := nil.
	observer := nil.
	^ true
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> stop [

	self hasObserver ifTrue: [ self removeObserver ].
	super stop
]
