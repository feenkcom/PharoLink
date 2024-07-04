Class {
	#name : #LanguageLinkApplication,
	#superclass : #Object,
	#traits : 'TGtPharoLinkPlayground',
	#classTraits : 'TGtPharoLinkPlayground classTrait',
	#instVars : [
		'communicationHandler',
		'processHandler',
		'loggingHandler',
		'executionHandler',
		'settings'
	],
	#classVars : [
		'announcer'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
LanguageLinkApplication class >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
LanguageLinkApplication class >> defaultSettings [

	^ LanguageLinkSettings pharoDefaultSettings
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> do: aBlockClosure [ 
	| returnValue |
	self isRunning ifTrue: [ ^ aBlockClosure cull: self uniqueInstance ].
	[
		self start.
		returnValue := aBlockClosure cull: self uniqueInstance.
		self uniqueInstance newCommandFactory 
			<< nil; 
			sendAndWait ] ensure: [ self stop ].
	^ returnValue
]

{ #category : #testing }
LanguageLinkApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> killAll [
	"Stop ALL instances of the receiver and kill any server processes that may still be running."
	| allInstances firstApplication wd proc error |

	allInstances := self allInstances.
	allInstances ifEmpty: [ ^ self ].
	firstApplication := allInstances
		detect: #isRunning 
		ifNone: [ allInstances first ].
	allInstances do: #stop.
	wd := firstApplication settings workingDirectory.
	proc := GtSubprocessWithInMemoryOutput new command: (wd / 'killservers.sh') fullName.
	proc runAndWait.
	proc isSuccess ifFalse: 
		[ error:= LanguageLinkProcessError new
			messageText: 'Unable to kill server processes';
			application: firstApplication;
			process: proc.
			error signal ].
	self assert: proc stderr trimBoth isEmpty.
	^ proc stdout
]

{ #category : #'instance creation' }
LanguageLinkApplication class >> newWith: aLLSettings [
	"Answer a new instance initialised with the supplied settings"

	^ self new initializeWith: aLLSettings 
]

{ #category : #'pipenv setup' }
LanguageLinkApplication class >> platform [

	^ self defaultSettings platform
]

{ #category : #'python hooks file' }
LanguageLinkApplication class >> repositoryFileReference [
	^ self platform folderForApplication
]

{ #category : #instructions }
LanguageLinkApplication class >> resetUniqueInstance [
	uniqueInstance ifNotNil: [ 
		[ uniqueInstance stop ] 
			on: Error 
			do: [ self platform uiManager inform: 'Error on reseting unique instance.' ]. ].
	uniqueInstance := nil
]

{ #category : #instructions }
LanguageLinkApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> start [

	^ self startWith: LanguageLinkSettings pharoDefaultSettings.
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> startWith: settings [

	self isRunning ifTrue: [ ^ uniqueInstance ].
	self stop.
	uniqueInstance := self new initializeWith: settings.
	uniqueInstance start.
	^ uniqueInstance.
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> stop [
	uniqueInstance ifNotNil: [ 
		uniqueInstance stop. ].
	uniqueInstance := nil
]

{ #category : #testing }
LanguageLinkApplication class >> test [
	self assert: (self do: [ :app | 
			app newCommandFactory
				<< (JSGBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself);
				sendAndWait ]) = 3
]

{ #category : #instructions }
LanguageLinkApplication class >> uniqueInstance [
	^ uniqueInstance
]

{ #category : #accessing }
LanguageLinkApplication class >> uniqueInstance: anObject [
	uniqueInstance := anObject
]

{ #category : #'instance creation' }
LanguageLinkApplication class >> withDefaultSettings [
	"Answer a new instance configured with default settings"

	^ self newWith: self defaultSettings
]

{ #category : #utils }
LanguageLinkApplication >> addMapping: jsType to: mapFunction [

		^ self subclassResponsibility 
]

{ #category : #accessing }
LanguageLinkApplication >> communicationHandler [
	^ communicationHandler
]

{ #category : #accessing }
LanguageLinkApplication >> debugMode [

	^ settings debugMode
]

{ #category : #accessing }
LanguageLinkApplication >> debugMode: aBoolean [

	settings debugMode: aBoolean
]

{ #category : #accessing }
LanguageLinkApplication >> errorMessage [
	"Fetch the error message from the stderr stream, from the processhander"
	^ processHandler errorMessage
]

{ #category : #evaluating }
LanguageLinkApplication >> evaluateAndWait: aString [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		<< aString;
		sendAndWait.

]

{ #category : #accessing }
LanguageLinkApplication >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkApplication >> gtDetailsFor: aView [
	<gtView>
	| formatter |
	formatter := [ :boolean | boolean asRopedText 
		foreground: (boolean 
						ifTrue: BrGlamorousColors successBorderColor 
						ifFalse: BrGlamorousColors errorBorderColor) ].
	^ aView columnedList
		title: 'Details';
		priority: 30;
		items: [ {
			{ 'Server process running' 
				. formatter value: self processHandler isRunning
				. self processHandler isRunning }.
			{ 'Server socket address' . self settings serverSocketAddress }.
			{ 'Server process path' . [ self serverPath ] on: MessageNotUnderstood do: [ '' ] }.
			{ 'Server process directory' . self settings workingDirectory }.
			{ 'Client process running'
				. formatter value: self isRunning 
				. self isRunning }.
			{ 'Client socket address' . self settings clientSocketAddress }.
		} ];
		column: #key text: #first weight: 0.5;
		column: #value text: #second;
		send: #last;
		updateWhen: LanguageLinkStartStopAnnouncement in: [ LanguageLinkApplication announcer ];
		actionUpdateButton
]

{ #category : #accessing }
LanguageLinkApplication >> gtInternalsFor: aView [
	<gtView>
	| formatter |
	^ aView columnedList
		title: 'Internals';
		priority: 70;
		items: [ {
			{ 'logging handler' . loggingHandler }.
			{ 'process handler' . processHandler }.
			{ 'communication handler' . communicationHandler }.
			{ 'execution handler' . executionHandler }.
			{ 'settings' . settings } } ];
		column: #key text: #first;
		column: #value text: #second weight: 3;
		send: #last;
		actionUpdateButton
]

{ #category : #ui }
LanguageLinkApplication >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		aptitude: BrGlamorousCodeEditorAptitude;
		priority: 100;
		text: [ self gtPlaygroundText ];
		styler: self settings parserClass gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				self gtPlaygroundSaveSource: statements.
				result := [ self evaluateSourceSequence: statements ]
					on: PharoLinkRemoteError, PharoLinkParserError
					do: [ :ex | ex ].
				aButton phlow spawnObject: result ].

]

{ #category : #accessing }
LanguageLinkApplication >> gtRestartActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons refresh;
		tooltip: 'Restart this language link application';
		priority: 15;
		action: [ self restart ]
]

{ #category : #ui }
LanguageLinkApplication >> gtSettingsFor: aView [
	<gtView>

	^ aView forward 
		title: 'Settings';
		priority: 60;
		object: [ settings ];
		view: #gtSettingsFor:
]

{ #category : #accessing }
LanguageLinkApplication >> gtStartStopActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons shutdown;
		tooltip: 'Start/stop this language link application';
		priority: 10;
		action: [ self toggleStartStop ]
]

{ #category : #ui }
LanguageLinkApplication >> gtStatusFor: aView [

	<gtView>
	^ aView textEditor
		  title: 'Status';
		  priority: 50;
		  text: [ self serverStatus asRopedText glamorousCodeFont ];
		  updateWhen: LanguageLinkStartStopAnnouncement in: [ LanguageLinkApplication announcer ];
		  actionUpdateButton
]

{ #category : #ui }
LanguageLinkApplication >> gtStderrFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Stderr';
		priority: 55;
		text: [ processHandler stderr ];
		actionUpdateButton
]

{ #category : #ui }
LanguageLinkApplication >> gtStdoutFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Stdout';
		priority: 55;
		text: [ processHandler stdout ];
		actionUpdateButton
]

{ #category : #handlers }
LanguageLinkApplication >> handlers [
	^ Array
		with: loggingHandler
		with: processHandler
		with: communicationHandler
		with: executionHandler
]

{ #category : #initialization }
LanguageLinkApplication >> initializeHandlers [

	^ self subclassResponsibility 
]

{ #category : #initialization }
LanguageLinkApplication >> initializeWith: aLLSettings [

	settings := aLLSettings.
	self initializeHandlers.
]

{ #category : #testing }
LanguageLinkApplication >> isRunning [
	^ self handlers allSatisfy: #isRunning
]

{ #category : #testing }
LanguageLinkApplication >> isServerReady [
	"Ensures python webserver is ready for receiving commands"
	^ self communicationHandler isServerReady
]

{ #category : #logging }
LanguageLinkApplication >> log: aLog [
	self loggingHandler log: aLog
]

{ #category : #accessing }
LanguageLinkApplication >> loggingHandler [
	^ loggingHandler
]

{ #category : #'instance creation' }
LanguageLinkApplication >> newCommand [

	^ self settings commandClass forApplication: self.
]

{ #category : #'instance creation' }
LanguageLinkApplication >> newCommandFactory [
	^ self settings commandFactoryClass new 
		application: self;
		yourself
]

{ #category : #instructions }
LanguageLinkApplication >> notifyDebuggerPaused: aDebugger [
	"Notify all promises that the server debugger has paused in case the Bloc UI process is waiting on one of the promises."

	self executionHandler notifyDebuggerPaused: aDebugger.
]

{ #category : #accessing }
LanguageLinkApplication >> platform [ 

	^self settings platform
]

{ #category : #'start-stop' }
LanguageLinkApplication >> postInitialization [
	"Hook that is called after all handlers are started and 
	#waitInitialization found #isServerReady to be true.
	This means communication with the language server could be established."
]

{ #category : #accessing }
LanguageLinkApplication >> processHandler [
	^ processHandler
]

{ #category : #accessing }
LanguageLinkApplication >> registerObject: aProxyObject [

	self executionHandler registerObject: aProxyObject
]

{ #category : #accessing }
LanguageLinkApplication >> remoteAddressString [

	^ communicationHandler remoteAddressString.
]

{ #category : #'start-stop' }
LanguageLinkApplication >> restart [
	self isRunning
		ifTrue: [ 
			self stop.
			0.5 seconds wait ].
	self start
]

{ #category : #instructions }
LanguageLinkApplication >> send: aCommand [
	self isRunning ifFalse: 
		[ LanguageLinkServerNotRunningError new
			application: self;
			signal ].
	^ executionHandler sendCommand: aCommand
]

{ #category : #accessing }
LanguageLinkApplication >> serverPath [
	"Answer the file reference to the server's executable"

	^ processHandler serverPath
]

{ #category : #printing }
LanguageLinkApplication >> serverStatus [
	"Answer a string describing the environment and server status.
	Mostly for problem solving."

	^ String streamContents: [ :stream |
		self serverStatusOn: stream process: processHandler ]
]

{ #category : #printing }
LanguageLinkApplication >> serverStatusOn: aStream process: process [
	"Write the environment and server status on the supplied stream.
	Mostly for problem solving."
	| serverPathString |

	serverPathString := [ self serverPath isExecutable
		ifTrue: [ self serverPath fullName ]
		ifFalse: [ self serverPath fullName, ': doesn''t exist or isn''t executable, it should be in the PATH' ] ]
			on: Error
			do: [ '<Unable to determine server path.  It should be in the PATH>' ].
	aStream
		<< 'Running:                 ';
			print: self isRunning; cr;
		<< 'Server:                  ';
			<< serverPathString; cr;
		<< 'Working directory:       ';
			<< settings workingDirectory fullName; cr;
		<< 'Server process  running: ';
			print: process isRunning; cr.
	process hasProcess ifFalse: [ ^ self ].
	process isRunning ifFalse: 
		[ aStream 
			<< 'Exit status:             ';
			print: process exitCode; cr ].
	aStream
		cr; cr;
		<< 'Stdout:'; cr;
			<< process stdout; cr;
		cr; cr;
		<< 'Stderr:'; cr;
			<< process stderr.
]

{ #category : #accessing }
LanguageLinkApplication >> settings [
	^ settings
]

{ #category : #accessing }
LanguageLinkApplication >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
LanguageLinkApplication >> start [
	self handlers do: #start.
	self waitInitialization.
	self postInitialization.
	self newCommandFactory send.
	self class announcer 
		announce: (LanguageLinkStartAnnouncement new subject: self; yourself)
]

{ #category : #accessing }
LanguageLinkApplication >> stderr [

	^ processHandler stderr
]

{ #category : #accessing }
LanguageLinkApplication >> stdout [

	^ processHandler stdout
]

{ #category : #'start-stop' }
LanguageLinkApplication >> stop [
	self handlers reversed select: #notNil thenDo: #stop.
	self class announcer
		announce: (LanguageLinkStopAnnoucement new subject: self; yourself)
]

{ #category : #'start-stop' }
LanguageLinkApplication >> toggleStartStop [
	self isRunning ifTrue: [ self stop ] ifFalse: [ self start ]
]

{ #category : #initialization }
LanguageLinkApplication >> waitInitialization [
	"Timeout of 10 seconds and try every 0.5 seconds"
	1 to: 20 by: 0.5 do: [ :t |
		LlEsCheckServerReadyStartingSignal new emit.
		self isServerReady ifTrue: 
			[ LlEsCheckServerReadyCompletedSignal new
				isServerReady: true;
				emit.
			^ self ]
		ifFalse: 
			[ LlEsCheckServerReadyCompletedSignal new
				isServerReady: false;
				emit.
			(Delay forMilliseconds: 500) wait ] ].
	self error: 'The server initialization failed!'.
]
