Class {
	#name : #PharoLinkWorkerLocalPool,
	#superclass : #Object,
	#instVars : [
		'size',
		'watchDog',
		'processes',
		'server'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerLocalPool >> finalize [

	self stop.
	super finalize
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> initialize [

	super initialize.
	size := 2.
	processes := OrderedCollection new.
	server := PharoLinkWorkerServer new
		          listenPort: 9000;
		          yourself
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> isRunning [

	^ watchDog isNotNil
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> start [

	self assert: processes isEmpty.
	self assert: self isRunning not.
	server start.
	watchDog := [ 
	            [ 
	            | broken |
	            broken := processes reject: #isRunning.
	            broken do: [ :e | 
		            | process |
		            process := server newWorkerLocalProcess.
		            process run.
		            processes
			            remove: e;
			            add: process ].
	            1 minute wait ] repeat ] forkNamed:
		            'PharoLinkWorkerPool watch dog'.
	size timesRepeat: [ 
		| process |
		process := server newWorkerLocalProcess.
		process run.
		processes add: process ]
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> stop [

	self assert: self isRunning.
	[ watchDog terminate ]
		on: ProcessAlreadyTerminating
		do: [ "noop" ].
	watchDog := nil.
	processes
		do: #terminate;
		removeAll.
	server stop
]
