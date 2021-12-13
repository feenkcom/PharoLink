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
	observer := commandFactory observerFromCallback: [ :selector | "can be any method named 'command.*'"
		            self perform: #command , selector.
		            true ].
	"register needs to keep request alive to keep observer alive"
	^ commandFactory send: ('connection addObserver: {1}' format:
			   { observer pharoLinkFormattedCode })
]

{ #category : #accessing }
PharoLinkWorkerService >> application: anApplication [

	application := anApplication
]

{ #category : #commands }
PharoLinkWorkerService >> commandCancelCurrentTask [

	"figure out if we need to catch some errors"
	taskWorker currentTaskExecution cancel
]

{ #category : #commands }
PharoLinkWorkerService >> commandPing [

	"Note that we must not wait for a response, as this leads to a deadlock"

	application newCommandFactory send: 'connection notifyPing. true'
]

{ #category : #commands }
PharoLinkWorkerService >> commandQuitSmalltalk [

	Smalltalk image snapshot: false andQuit: true
]

{ #category : #initialization }
PharoLinkWorkerService >> initialize [

	super initialize.
	taskWorker := TKTWorker new
]

{ #category : #accessing }
PharoLinkWorkerService >> name [

	^ 'PharoLinkWorker poll service'
]

{ #category : #tasks }
PharoLinkWorkerService >> next [

	| promise |
	promise := application newCommandFactory send:
		'LeJsonV4 uniqueInstance serialize: taskQueue next'.
	^ LeJsonV4 uniqueInstance deserialize: promise waitForValue readStream
]

{ #category : #tasks }
PharoLinkWorkerService >> notifyDone: aTask with: anObject [

	StringSignal emit: ('done {1} with {2}' format: { 
				 aTask.
				 anObject }).
	^ application newCommandFactory
		  bindingAt: #taskId put: aTask id;
		  bindingAt: #result
		  put: (LeJsonV4 uniqueInstance serialize: anObject);
		  sendAndWait:
			  'taskQueue notifyDone: taskId with: (LeJsonV4 uniqueInstance deserialize: result readStream). true'
]

{ #category : #tasks }
PharoLinkWorkerService >> notifyFailed: aTask with: anError [

	StringSignal emit: ('failed {1} with {2}' format: { 
				 aTask.
				 anError }).
	^ application newCommandFactory
		  bindingAt: #taskId put: aTask id;
		  bindingAt: #stackString put: anError stackString;
		  sendAndWait:
			  'taskQueue notifyFailed: taskId with: stackString. true'
]

{ #category : #observer }
PharoLinkWorkerService >> removeObserver [

	^ application newCommandFactory send: 'connection removeObserver'
]

{ #category : #tasks }
PharoLinkWorkerService >> run: aTask [

	| result error |
	StringSignal emit: ('run {1}' format: { aTask }).
	[ result := aTask run ]
		on: Error
		do: [ :e | 
			e freeze.
			error := e ].
	error
		ifNil: [ self notifyDone: aTask with: result ]
		ifNotNil: [ self notifyFailed: aTask with: error ]
]

{ #category : #starting }
PharoLinkWorkerService >> setUp [

	super setUp.
	taskWorker start
]

{ #category : #accessing }
PharoLinkWorkerService >> start [

	application start.
	super start
]

{ #category : #stepping }
PharoLinkWorkerService >> stepService [

	| task future |
	5 seconds wait.
	true ifTrue: [ ^ self ].
	task := self next.
	future := taskWorker future: [ self run: task ].
	future onFailureDo: [ :r | Halt once "not sure what to do here" ].
	[ future waitForCompletion: 5 minutes ]
		on: TKTTimeoutException
		do: [ :e | Halt once "...or here" ]
]

{ #category : #accessing }
PharoLinkWorkerService >> stop [

	super stop.
	application stop
]

{ #category : #starting }
PharoLinkWorkerService >> tearDown [

	taskWorker stop.
	super tearDown
]
