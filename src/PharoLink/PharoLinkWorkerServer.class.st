Class {
	#name : #PharoLinkWorkerServer,
	#superclass : #PharoLinkServer,
	#instVars : [
		'scheduler'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerServer >> initialize [

	super initialize.
	self scheduler: PharoLinkWorkerScheduler new
]

{ #category : #accessing }
PharoLinkWorkerServer >> newWorkerLocalProcess [

	| settings args |
	self flag: 'TODO settings should come from outside'.
	settings := LanguageLinkSettings pharoDefaultSettings.
	args := OrderedCollection new.
	args
		add: settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkWorker'.
	self debugMode ifTrue: [ args add: '--log' ].
	args
		add: '--taskPollForever';
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
PharoLinkWorkerServer >> scheduler [

	^ scheduler
]

{ #category : #accessing }
PharoLinkWorkerServer >> scheduler: aScheduler [

	scheduler := aScheduler.
	globals at: #scheduler put: scheduler
]
