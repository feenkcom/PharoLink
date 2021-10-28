Class {
	#name : #PharoLinkServer,
	#superclass : #Object,
	#instVars : [
		'listenPort',
		'responsePort',
		'responseHost',
		'znServer',
		'debugMode',
		'registry',
		'globals'
	],
	#category : 'PharoLink-Server'
}

{ #category : #clap }
PharoLinkServer class >> commandLine [
	<commandline>

	SystemVersion current major = 8 ifTrue: 
		[ ^ self commandLine8 ].

	^ self commandLineCommand meaning: [ :args | 
		  | logger listenPort responseHostPort |
		  args at: #help ifPresent: [ :help | 
			  help value.
			  help context exitSuccess ].

		  args at: #log ifPresent: [ 
			  SignalLogger resetAllInstances.
			  logger := RestartingStreamLogger stdout.
			  logger start ].

		  listenPort := (args at: #listenPort) value asNumber.
		  responseHostPort := (args at: #responsePort) value.
		  StringSignal emit: 'Listen Port: ' , listenPort printString.
		  StringSignal emit: 'Response Port: ' , responseHostPort printString.
		  self new
			  listenPort: listenPort;
			  responseHostPort: responseHostPort;
			  start.
		  StringSignal emit: 'Running'.

		  "Wait until the process is killed"
		  Semaphore new wait ]
]

{ #category : #clap }
PharoLinkServer class >> commandLine8 [

	^ self commandLineCommand8 meaning: [ :args | | logger listenPort responsePort |
		args atName: 'help' ifFound: [ :help |
			help value.
			help context exitSuccess ].

		args atName: 'log' ifFound: 
			[ SignalLogger resetAllInstances.
			logger := RestartingStreamLogger stdout.
			logger start ].

		listenPort := (args atName: 'listenPort') value asNumber.
		responsePort := (args atName: 'responsePort') value.
		StringSignal emit: 'Listen Port: ', listenPort printString.
		StringSignal emit: 'Response Port: ', responsePort printString.
		self new 
			listenPort: listenPort;
			responseHostPort: responsePort;
			start.
		StringSignal emit: 'Running'.
		
		"Wait until the process is killed"
		Semaphore new wait.
		 ].
]

{ #category : #clap }
PharoLinkServer class >> commandLineCommand [

	SystemVersion current major = 8 ifTrue: 
		[ ^ self commandLineCommand8 ].

	^ (ClapCommand id: 'pharoLinkServer')
		  description: 'Run the PharoLink Server';
		  add: ClapFlag forHelp;
		  add:
			  ((ClapFlag id: 'log') description: 'Enable logging to stdout');
		  add: ((ClapPositional id: 'listenPort') description:
					   'The port number on which to listen for requests');
		  add: ((ClapPositional id: 'responsePort') description:
					   'The [host:]port on which to send responses');
		  yourself
]

{ #category : #clap }
PharoLinkServer class >> commandLineCommand8 [

	^ (ClapCommand withName: 'pharoLinkServer')
		description: 'Run the PharoLink Server';
		add: ClapFlag forHelp;
		add: ((ClapFlag withName: 'log') 
					description: 'Enable logging to stdout');
		add: ((ClapPositional withName: 'listenPort')
					description: 'The port number on which to listen for requests');
		add: ((ClapPositional withName: 'responsePort')
					description: 'The [host:]port on which to send responses');
		yourself
]

{ #category : #accessing }
PharoLinkServer >> debugMode [
	^ debugMode
]

{ #category : #private }
PharoLinkServer >> handleIsAlive: aZnRequest [
	"Respond to the ping request"

	^ (ZnResponse statusLine: ZnStatusLine ok)
		entity: (ZnEntity json: '{}');
		yourself
]

{ #category : #private }
PharoLinkServer >> handlEnqueue: aZnRequest [
	"Process the supplied statements"
	| command dict |

	dict := PharoLinkServerSerializer 
					deserialize: aZnRequest entity contents
					registry: registry.
	command := PharoLinkEvalCommand
					source: (dict at: #'statements')
					bindings: (dict at: #'bindings')
					id: (dict at: #'commandId').
	command 
		responseHost: responseHost;
		responsePort: responsePort;
		registry: registry.
"self halt: (dict at: #statements)."
	[ command execute: globals ] forkAt: Processor userBackgroundPriority.
	^ (ZnResponse statusLine: ZnStatusLine ok)
		entity: (ZnEntity json: '{}');
		yourself
]

{ #category : #private }
PharoLinkServer >> handleRequest: aZnRequest [
	"Process a request from the client.
	Only two types are currently handled:
	- /IS_ALIVE is a ping to test that the receiver is running.
	- /ENQUEUE requests a collection of statements be evaluated."
	| command |

	command := aZnRequest url firstPathSegment.
	command = 'ENQUEUE' ifTrue: [ ^self handlEnqueue: aZnRequest ].
	command = 'IS_ALIVE' ifTrue: [ ^self handleIsAlive: aZnRequest ].

	^ (ZnResponse statusLine: ZnStatusLine badRequest)
		entity: (ZnEntity text: 'Invalid Request');
		yourself.
]

{ #category : #initialization }
PharoLinkServer >> initialize [ 

	super initialize.
	registry := PharoLinkRegistry new.
	globals := Dictionary new.
	globals at: #registry put: registry.
	debugMode := false.
	responseHost := 'localhost'.
]

{ #category : #testing }
PharoLinkServer >> isRunning [ 

	^ znServer isRunning
]

{ #category : #accessing }
PharoLinkServer >> listenPort [
	^ listenPort
]

{ #category : #accessing }
PharoLinkServer >> listenPort: anObject [
	listenPort := anObject
]

{ #category : #accessing }
PharoLinkServer >> responseHost [
	^ responseHost
]

{ #category : #accessing }
PharoLinkServer >> responseHost: anObject [
	responseHost := anObject
]

{ #category : #accessing }
PharoLinkServer >> responseHostPort: aString [
	"Accept a string of the form [host:]port and set the host and port appropriately"
	| segments |

	(aString includes: $:) ifFalse: 
		[ responsePort := aString asNumber.
		^ self ].

	segments := $: split: aString.
	self
		assert: segments size = 2
		description: 'The respose address must be in the form [host:]port'.
	responseHost := segments first.
	responsePort := segments second asNumber.
]

{ #category : #accessing }
PharoLinkServer >> responsePort [
	^ responsePort
]

{ #category : #accessing }
PharoLinkServer >> responsePort: anObject [
	responsePort := anObject
]

{ #category : #'start-stop' }
PharoLinkServer >> setDebugMode [

	debugMode := true.
	znServer ifNotNil: [ znServer debugMode: true ]
]

{ #category : #'start-stop' }
PharoLinkServer >> start [ 
	"Start the receiver's ZnServer"

	self assert: listenPort isNotNil.

	znServer := ZnServer on: listenPort.
	znServer debugMode: debugMode.
	debugMode ifFalse: [ znServer loggingOff ].
	znServer start.
	self
		assert: znServer isRunning & znServer isListening
		description:
			('Failed to start server on port {1}. Is there one already?' format: {znServer port}).
	znServer onRequestRespond: [ :req | self handleRequest: req ].
]

{ #category : #'start-stop' }
PharoLinkServer >> stop [
	"Stop the receiver's ZnServer"

	znServer ifNotNil: 
		[ znServer stop.
		znServer := nil ].
]
