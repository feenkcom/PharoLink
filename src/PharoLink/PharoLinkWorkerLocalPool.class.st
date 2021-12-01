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

]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> isRunning [

	^ watchDog isNotNil
]

{ #category : #private }
PharoLinkWorkerLocalPool >> newWorkerLocalProcess [

	| settings args |
	self flag: 'TODO settings should come from outside'.
	settings := LanguageLinkSettings pharoDefaultSettings.
	args := OrderedCollection new.
	args
		add: settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkWorker'.
	server debugMode ifTrue: [ args add: '--log' ].
	args
		add: '--taskPollForever';
		add: server listenPort asString;
		add: '--detachChangesFromFileSystem'.
	^ GtSubprocessWithInMemoryOutput new
		  command: settings serverExecutable fullName;
		  arguments: args;
		  workingDirectory: settings workingDirectory resolve fullName;
		  terminateOnShutdown;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> server [

	^ server
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> server: anObject [

	server := anObject
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> size [

	^ size
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> size: anObject [

	size := anObject
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
		            process := self newWorkerLocalProcess.
		            process run.
		            processes
			            remove: e;
			            add: process ].
	            1 minute wait ] repeat ] forkNamed:
		            'PharoLinkWorkerPool watch dog'.
	size timesRepeat: [ 
		| process |
		process := self newWorkerLocalProcess.
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
