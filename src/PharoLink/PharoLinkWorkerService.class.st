Class {
	#name : #PharoLinkWorkerService,
	#superclass : #TKTService,
	#instVars : [
		'id',
		'application'
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
		  args at: #registerObserver ifPresent: [ service registerObserver ] ]
]

{ #category : #accessing }
PharoLinkWorkerService class >> commandLineCommand [

	^ (ClapCommand id: #pharoLinkWorker)
		  description: 'Run the PharoLink worker';
		  add: ClapFlag forHelp;
		  add: ((ClapFlag id: #log) description: 'Enable logging to stdout');
		  add: ((ClapFlag id: #registerObserver) description:
					   'Register observer to open a callback channel for control');
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

{ #category : #accessing }
PharoLinkWorkerService >> application: anApplication [

	application := anApplication
]

{ #category : #commands }
PharoLinkWorkerService >> commandCancelCurrentTask [

	Halt once.
	"figure out if we need to catch some errors"
	worker currentTaskExecution cancel
]

{ #category : #commands }
PharoLinkWorkerService >> commandPing [

	^ application newCommandFactory sendAndWait:
		  'LeJsonV4 uniqueInstance serialize: taskQueue ping'
]

{ #category : #commands }
PharoLinkWorkerService >> commandQuitSmalltalk [

	Smalltalk image snapshot: false andQuit: true
]

{ #category : #initialization }
PharoLinkWorkerService >> initialize [

	super initialize.
	id := 'plw' , UUID new asString36.
	worker := TKTWorker new
]

{ #category : #accessing }
PharoLinkWorkerService >> name [

	^ 'PharoLinkWorker poll service'
]

{ #category : #observer }
PharoLinkWorkerService >> registerObserver [

	| commandFactory observer |
	commandFactory := application newCommandFactory.
	observer := commandFactory observerFromCallback: [ :selector | "can be any method named 'command.*'"
		            self perform: #command, selector ].
	"register needs to keep request alive to keep observer alive"
	^ commandFactory send:
		  ('taskQueue registerObserver: ''{1}'' with: {2}' format: { 
				   id.
				   observer pharoLinkFormattedCode })
]

{ #category : #starting }
PharoLinkWorkerService >> setUp [

	super setUp.
	worker start
]

{ #category : #stepping }
PharoLinkWorkerService >> stepService [

	| task future |
	task := self taskPoll.
	future := worker future: [ self taskRun: task ].
	future onFailureDo: [ :r | Halt once "not sure what to do here" ].
	[ future waitForCompletion: 5 minutes ]
		on: TKTTimeoutException
		do: [ :e | Halt once "...or here" ]
]

{ #category : #tasks }
PharoLinkWorkerService >> taskDone: aTask with: anObject [

	StringSignal emit: ('done {1} with {2}' format: { 
				 aTask.
				 anObject }).
	^ application newCommandFactory
		  bindingAt: #taskId put: aTask id;
		  bindingAt: #result
		  put: (LeJsonV4 uniqueInstance serialize: anObject);
		  sendAndWait:
			  'taskQueue taskDone: taskId with: (LeJsonV4 uniqueInstance deserialize: result readStream). true'
]

{ #category : #tasks }
PharoLinkWorkerService >> taskFailed: aTask with: anError [

	StringSignal emit: ('failed {1} with {2}' format: { 
				 aTask.
				 anError }).
	^ application newCommandFactory
		  bindingAt: #taskId put: aTask id;
		  bindingAt: #stackString put: anError stackString;
		  sendAndWait:
			  'taskQueue taskFailed: taskId with: stackString. true'
]

{ #category : #tasks }
PharoLinkWorkerService >> taskPoll [

	| promise |
	promise := application newCommandFactory send:
		'LeJsonV4 uniqueInstance serialize: taskQueue taskPoll'.
	^ LeJsonV4 uniqueInstance deserialize: promise waitForValue readStream
]

{ #category : #tasks }
PharoLinkWorkerService >> taskRun: aTask [

	| result error |
	StringSignal emit: ('run {1}' format: { aTask }).
	[ result := aTask run ]
		on: Error
		do: [ :e | 
			e freeze.
			error := e ].
	error
		ifNil: [ self taskDone: aTask with: result ]
		ifNotNil: [ self taskFailed: aTask with: error ]
]

{ #category : #starting }
PharoLinkWorkerService >> tearDown [

	worker stop.
	super tearDown
]

{ #category : #observer }
PharoLinkWorkerService >> unregisterObserver [

	^ application newCommandFactory send:
		  ('taskQueue unregisterObserver: ''{1}''' format: { id })
]
