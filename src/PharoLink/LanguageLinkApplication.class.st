Class {
	#name : 'LanguageLinkApplication',
	#superclass : 'Object',
	#traits : 'TGtPharoLinkPlayground',
	#classTraits : 'TGtPharoLinkPlayground classTrait',
	#instVars : [
		'communicationHandler',
		'processHandler',
		'loggingHandler',
		'executionHandler',
		'settings'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'PharoLink-Global'
}

{ #category : 'accessing' }
LanguageLinkApplication class >> defaultSettings [

	^ LanguageLinkSettings pharoDefaultSettings
]

{ #category : 'start-stop' }
LanguageLinkApplication class >> do: aBlockClosure [ 
	| retVal |
	self isRunning ifTrue: [ ^ aBlockClosure value ].
	[
		self start.
		retVal := aBlockClosure cull: self uniqueInstance.
		self uniqueInstance commandFactory << nil.
		self uniqueInstance commandFactory send waitForValue. ] ensure: [ self stop ].
	^ retVal
]

{ #category : 'testing' }
LanguageLinkApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
]

{ #category : 'start-stop' }
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
	proc := GtUnixSubprocess new command: (wd / 'killservers.sh') fullName.
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

{ #category : 'testing' }
LanguageLinkApplication class >> module [
	^ self uniqueInstance module
]

{ #category : 'instance creation' }
LanguageLinkApplication class >> newWith: aLLSettings [
	"Answer a new instance initialised with the supplied settings"

	^ self new initializeWith: aLLSettings 
]

{ #category : 'pipenv setup' }
LanguageLinkApplication class >> platform [

	^ self defaultSettings platform
]

{ #category : 'python hooks file' }
LanguageLinkApplication class >> repositoryFileReference [
	^ self platform folderForApplication
]

{ #category : 'instructions' }
LanguageLinkApplication class >> resetUniqueInstance [
	uniqueInstance ifNotNil: [ 
		[ uniqueInstance stop ] 
			on: Error 
			do: [ self platform uiManager inform: 'Error on reseting unique instance.' ]. ].
	uniqueInstance := nil
]

{ #category : 'instructions' }
LanguageLinkApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
]

{ #category : 'start-stop' }
LanguageLinkApplication class >> start [

	^ self startWith: LanguageLinkSettings pharoDefaultSettings.
]

{ #category : 'start-stop' }
LanguageLinkApplication class >> startWith: settings [

	self isRunning ifTrue: [ ^ uniqueInstance ].
	self stop.
	uniqueInstance := self new initializeWith: settings.
	uniqueInstance start.
	^ uniqueInstance.
]

{ #category : 'start-stop' }
LanguageLinkApplication class >> stop [
	uniqueInstance ifNotNil: [ 
		uniqueInstance stop. ].
	uniqueInstance := nil
]

{ #category : 'testing' }
LanguageLinkApplication class >> test [ 
	self assert: (self do: [ :app |
		app commandFactory << (JSGBinaryOperator new
                     left: 1;
                     right: 2;
                     operator: $+;
                     yourself).
		app commandFactory send waitForValue
	  ]) = 3
]

{ #category : 'instructions' }
LanguageLinkApplication class >> uniqueInstance [
	^ uniqueInstance
]

{ #category : 'accessing' }
LanguageLinkApplication class >> uniqueInstance: anObject [
	uniqueInstance := anObject
]

{ #category : 'instance creation' }
LanguageLinkApplication class >> withDefaultSettings [
	"Answer a new instance configured with default settings"

	^ self newWith: self defaultSettings
]

{ #category : 'utils' }
LanguageLinkApplication >> addMapping: jsType to: mapFunction [

		^ self subclassResponsibility 
]

{ #category : 'accessing' }
LanguageLinkApplication >> communicationHandler [
	^ communicationHandler
]

{ #category : 'accessing' }
LanguageLinkApplication >> debugMode [

	^ settings debugMode
]

{ #category : 'accessing' }
LanguageLinkApplication >> debugMode: aBoolean [

	settings debugMode: aBoolean
]

{ #category : 'accessing' }
LanguageLinkApplication >> errorMessage [
	"Fetch the error message from the stderr stream, from the processhander"
	^ processHandler errorMessage
]

{ #category : 'evaluating' }
LanguageLinkApplication >> evaluateAndWait: aString [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		<< aString;
		sendAndWait.

]

{ #category : 'accessing' }
LanguageLinkApplication >> executionHandler [
	^ executionHandler
]

{ #category : 'ui' }
LanguageLinkApplication >> gtSettingsFor: aView [
	<gtView>

	^ aView forward 
		title: 'Settings';
		priority: 60;
		object: [ settings ];
		view: #gtSettingsFor:
]

{ #category : 'ui' }
LanguageLinkApplication >> gtStatusFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Status';
		priority: 50;
		text: [ self serverStatus asRopedText glamorousCodeFont ]
]

{ #category : 'handlers' }
LanguageLinkApplication >> handlers [
	^ Array
		with: loggingHandler
		with: communicationHandler
		with: processHandler
		with: executionHandler
]

{ #category : 'initialization' }
LanguageLinkApplication >> initializeHandlers [

	^ self subclassResponsibility 
]

{ #category : 'initialization' }
LanguageLinkApplication >> initializeWith: aLLSettings [

	settings := aLLSettings.
	self initializeHandlers.
]

{ #category : 'testing' }
LanguageLinkApplication >> isRunning [
	^ self handlers allSatisfy: #isRunning
]

{ #category : 'testing' }
LanguageLinkApplication >> isServerReady [
	"Ensures python webserver is ready for receiving commands"
	^ self communicationHandler isServerReady
]

{ #category : 'logging' }
LanguageLinkApplication >> log: aLog [
	self loggingHandler log: aLog
]

{ #category : 'accessing' }
LanguageLinkApplication >> loggingHandler [
	^ loggingHandler
]

{ #category : 'accessing' }
LanguageLinkApplication >> module [
	self subclassResponsibility
]

{ #category : 'instance creation' }
LanguageLinkApplication >> newCommand [

	^ self settings commandClass forApplication: self.
]

{ #category : 'instance creation' }
LanguageLinkApplication >> newCommandFactory [
	^ self settings commandFactoryClass new 
		application: self;
		yourself
]

{ #category : 'instructions' }
LanguageLinkApplication >> notifyDebuggerPaused: aDebugger [
	"Notify all promises that the server debugger has paused in case the Bloc UI process is waiting on one of the promises."

	self executionHandler notifyDebuggerPaused: aDebugger.
]

{ #category : 'accessing' }
LanguageLinkApplication >> platform [ 

	^self settings platform
]

{ #category : 'accessing' }
LanguageLinkApplication >> postInitialization [
	
]

{ #category : 'accessing' }
LanguageLinkApplication >> processHandler [
	^ processHandler
]

{ #category : 'accessing' }
LanguageLinkApplication >> registerObject: aProxyObject [

	self executionHandler registerObject: aProxyObject
]

{ #category : 'instructions' }
LanguageLinkApplication >> send: aCommand [
	self isRunning ifFalse: 
		[ LanguageLinkServerNotRunningError new
			application: self;
			signal ].
	^ executionHandler sendCommand: aCommand
]

{ #category : 'accessing' }
LanguageLinkApplication >> serverPath [
	"Answer the file reference to the server's executable"

	^ processHandler serverPath
]

{ #category : 'printing' }
LanguageLinkApplication >> serverStatus [
	"Answer a string describing the environment and server status.
	Mostly for problem solving."

	^ String streamContents: [ :stream |
		self serverStatusOn: stream process: processHandler ]
]

{ #category : 'printing' }
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

{ #category : 'accessing' }
LanguageLinkApplication >> settings [
	^ settings
]

{ #category : 'accessing' }
LanguageLinkApplication >> settings: anObject [
	settings := anObject
]

{ #category : 'start-stop' }
LanguageLinkApplication >> start [
	self handlers do: #start.
	self waitInitialization.
	self postInitialization.
	self newCommandFactory send.
]

{ #category : 'start-stop' }
LanguageLinkApplication >> stop [
	self handlers select: #notNil thenDo: #stop
]

{ #category : 'initialization' }
LanguageLinkApplication >> waitInitialization [
	"Timeout of 10 seconds and try every 0.5 seconds"
	1 to: 10 by: 0.5 do: [ :t |
		self isServerReady 
				ifTrue: [ ^ self ]
				ifFalse: [ (Delay forMilliseconds: 500) wait ] ].
	Error signal: 'The server initialization failed!'.
	"
	Print the result of executing the following line:
	
	self errorMessage
	"
]
