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
PharoLinkWorkerLocalPool class >> default [

	^ self port: 8442
]

{ #category : #accessing }
PharoLinkWorkerLocalPool class >> newServer: anInteger [

	^ PharoLinkServer new
		  listenPort: anInteger;
		  setDebugMode;
		  setTaskQueue;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerLocalPool class >> port: anInteger [

	^ self server: (self newServer: anInteger)
]

{ #category : #accessing }
PharoLinkWorkerLocalPool class >> server: aServer [

	^ self new
		  server: aServer;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> finalize [

	self stop.
	super finalize
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> initialize [

	super initialize.
	size := 2.
	processes := OrderedCollection new
]

{ #category : #accessing }
PharoLinkWorkerLocalPool >> isRunning [

	^ watchDog isNotNil
]

{ #category : #private }
PharoLinkWorkerLocalPool >> newWorkerProcess [

	| settings args |
	settings := LanguageLinkSettings pharoDefaultSettings.
	args := OrderedCollection new.
	args
		add: settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkWorker'.
	server debugMode ifTrue: [ args add: '--log' ].
	args
		add: '--registerObserver';
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
		            process := self newWorkerProcess.
		            process run.
		            processes
			            remove: e;
			            add: process ].
	            1 minute wait ] repeat ] forkNamed:
		            'PharoLinkWorkerPool watch dog'.
	size timesRepeat: [ 
		| process |
		process := self newWorkerProcess.
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
