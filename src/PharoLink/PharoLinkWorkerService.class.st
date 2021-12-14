Class {
	#name : #PharoLinkWorkerService,
	#superclass : #TKTService,
	#instVars : [
		'application',
		'taskWorker'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerService class >> application: anApplication [

	^ self new
		  application: anApplication;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerService class >> commandLine [

	<commandline>
	| service |
	^ self commandLineCommand meaning: [ :args | 
		  args
			  at: #help ifPresent: [ :help | 
				  help value.
				  help context exitSuccess ];
			  at: #log ifPresent: [ 
				  SignalLogger resetAllInstances.
				  RestartingStreamLogger stdout start ].
		  service := self serverSocketAddress:
			             (args at: #serverSocketAddress) value.
		  service start.
		  args at: #observer ifPresent: [ service addObserver ].
		  "wait to keep process alive"
		  Semaphore new wait ]
]

{ #category : #accessing }
PharoLinkWorkerService class >> commandLineCommand [

	^ (ClapCommand id: #pharoLinkWorkerService)
		  description: 'Run the PharoLink worker service';
		  add: ClapFlag forHelp;
		  add: ((ClapFlag id: #log) description: 'Enable logging to stdout');
		  add: ((ClapFlag id: #addObserver) description:
					   'Add an observer to open a callback channel for control');
		  add: ((ClapPositional id: #serverSocketAddress) description:
					   'The server socket address on which to connect for requests');
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerService class >> newPharoApplication: aString [

	^ PharoLinkApplication newWith:
		  (PharoLinkApplication defaultSettings
			   serverProcessClass: LanguageLinkManualProcess;
			   serverSocketAddress: (LanguageLinkSocketAddress from: aString);
			   debugMode: true;
			   yourself)
]

{ #category : #accessing }
PharoLinkWorkerService class >> serverSocketAddress: aString [

	^ self application: (self newPharoApplication: aString)
]

{ #category : #observer }
PharoLinkWorkerService >> addObserver [

	| commandFactory observer |
	commandFactory := application newCommandFactory.
	observer := commandFactory observerFromCallback: [ :selector | 
		            self command: selector ].
	"register needs to keep request alive to keep observer alive"
	^ commandFactory send: ('connection addObserver: {1}' format:
			   { observer pharoLinkFormattedCode })
]

{ #category : #accessing }
PharoLinkWorkerService >> application: anApplication [

	application := anApplication
]

{ #category : #observer }
PharoLinkWorkerService >> command: aSelector [

	"can be any method named 'command(aSelector)'"

	^ self perform: #command , aSelector
]

{ #category : #commands }
PharoLinkWorkerService >> commandPing [

	"Note that we must not wait for a response, as this leads to a deadlock"

	
]

{ #category : #commands }
PharoLinkWorkerService >> commandQuitSmalltalk [

	"Except connection closed."

	Smalltalk image snapshot: false andQuit: true
]

{ #category : #commands }
PharoLinkWorkerService >> commandTerminateCurrentTask [

	"figure out if we need to catch some errors"

	^ taskWorker currentTaskExecution ifNil: [ false ] ifNotNil: [ :e | 
		  e terminateWithReason: 'received TerminateCurrentTask'.
		  true ]
]

{ #category : #initialization }
PharoLinkWorkerService >> initialize [

	super initialize.
	taskWorker := TKTWorker new
]

{ #category : #accessing }
PharoLinkWorkerService >> kill [

	super kill.
	application stop.
	taskWorker stop
]

{ #category : #accessing }
PharoLinkWorkerService >> name [

	^ 'PharoLinkWorker poll service'
]

{ #category : #observer }
PharoLinkWorkerService >> removeObserver [

	^ application newCommandFactory send: 'connection removeObserver'
]

{ #category : #accessing }
PharoLinkWorkerService >> start [

	taskWorker start.
	application start.
	super start
]

{ #category : #stepping }
PharoLinkWorkerService >> stepService [

	| task future |
	task := self taskNext.
	future := taskWorker future: task.
	future
		onSuccessDo: [ :result | self taskNotifyDone: task with: result ];
		onFailureDo: [ :error | self taskNotifyFailed: task with: error ];
		waitForCompletion: 1 day
]

{ #category : #accessing }
PharoLinkWorkerService >> stop [

	super stop.
	application stop.
	taskWorker stop
]

{ #category : #tasks }
PharoLinkWorkerService >> taskNext [

	| promise |
	promise := application newCommandFactory send:
		'LeJsonV4 uniqueInstance serialize: connection taskNext'.
	^ LeJsonV4 uniqueInstance deserialize: promise waitForValue readStream
]

{ #category : #tasks }
PharoLinkWorkerService >> taskNotifyDone: aTask with: anObject [

	StringSignal emit: ('done {1} with {2}' format: { 
				 aTask.
				 anObject }).
	^ application newCommandFactory
		  bindingAt: #result
		  put: (LeJsonV4 uniqueInstance serialize: anObject);
		  sendAndWait:
			  'connection taskNotifyDoneWith: (LeJsonV4 uniqueInstance deserialize: result readStream). true'
]

{ #category : #tasks }
PharoLinkWorkerService >> taskNotifyFailed: aTask with: anError [

	StringSignal emit: ('failed {1} with {2}' format: { 
				 aTask.
				 anError }).
	^ application newCommandFactory
		  bindingAt: #stackString put: anError stackString;
		  sendAndWait: 'connection taskNotifyFailedWith: stackString. true'
]
