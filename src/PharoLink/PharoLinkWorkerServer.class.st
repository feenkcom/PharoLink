Class {
	#name : #PharoLinkWorkerServer,
	#superclass : #PharoLinkServer,
	#instVars : [
		'taskQueue'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerServer class >> port: anInteger [

	^ self new
		  listenPort: anInteger;
		  setDebugMode;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerServer >> connections [

	^ connections
]

{ #category : #accessing }
PharoLinkWorkerServer >> initialize [

	super initialize.
	taskQueue := PharoLinkWorkerTaskQueue new
]

{ #category : #accessing }
PharoLinkWorkerServer >> newConnection: aSocket [

	^ PharoLinkWorkerServerConnection
		  server: self
		  socket: aSocket
		  taskQueue: taskQueue
]

{ #category : #accessing }
PharoLinkWorkerServer >> newProcess [

	| settings args |
	settings := LanguageLinkSettings pharoDefaultSettings.
	args := OrderedCollection new.
	args
		add: settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkWorkerService'.
	debugMode ifTrue: [ args add: '--log' ].
	args
		add: '--addObserver';
		add: listenPort asString;
		add: '--detachChangesFromFileSystem'.
	^ GtSubprocessWithInMemoryOutput new
		  command: settings serverExecutable fullName;
		  arguments: args;
		  workingDirectory: settings workingDirectory resolve fullName;
		  terminateOnShutdown;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerServer >> newService [

	^ PharoLinkWorkerService serverSocketAddress: listenPort asString
]

{ #category : #accessing }
PharoLinkWorkerServer >> nextPut: aTask [

	^ taskQueue nextPut: aTask
]
