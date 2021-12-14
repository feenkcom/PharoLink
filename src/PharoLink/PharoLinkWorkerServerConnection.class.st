Class {
	#name : #PharoLinkWorkerServerConnection,
	#superclass : #PharoLinkServerConnection,
	#instVars : [
		'observer',
		'observerProcess',
		'taskQueue',
		'currentTask'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerServerConnection class >> server: aPharoLinkServer socket: aSocket taskQueue: aTaskQueue [

	^ self new
		  initializeTaskQueue: aTaskQueue;
		  initializeServer: aPharoLinkServer socket: aSocket;
		  yourself
]

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
PharoLinkWorkerServerConnection >> commandPing [

	"If the worker service responds, it is is there. If something fails, you get an error."

	^ observer value: #Ping
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> commandQuitSmalltalk [

	"Except the connection to close on the worker service end."

	^ observer value: #QuitSmalltalk
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> commandTerminateCurrentTask [

	^ observer value: #TerminateCurrentTask
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> currentTask [

	^ currentTask
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
PharoLinkWorkerServerConnection >> initializeTaskQueue: aTaskQueue [

	taskQueue := aTaskQueue
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> removeObserver [

	observerProcess ifNotNil: #terminate.
	observerProcess := nil.
	observer := nil.
	^ true
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> stop [

	self hasObserver ifTrue: [ self removeObserver ].
	currentTask := nil.
	super stop
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> taskNext [

	self assert: [ currentTask isNil ].
	^ currentTask := taskQueue next
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> taskNotifyDoneWith: anObject [

	self assert: [ currentTask isNotNil ].
	taskQueue notifyDone: currentTask id with: anObject.
	currentTask := nil
]

{ #category : #accessing }
PharoLinkWorkerServerConnection >> taskNotifyFailedWith: anObject [

	self assert: [ currentTask isNotNil ].
	taskQueue notifyFailed: currentTask id with: anObject.
	currentTask := nil
]
