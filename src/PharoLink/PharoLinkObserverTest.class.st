Class {
	#name : #PharoLinkObserverTest,
	#superclass : #PharoLinkTest,
	#instVars : [
		'server',
		'observer',
		'observerProcess',
		'semaphore',
		'clientProcess',
		'callbackProcess'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #helper }
PharoLinkObserverTest class >> connectAndRegisterObserver [
	"Start an application and register an observer to sleep and return a constant.
	Use by #testObserverOnDisconnect"
	| client settings observer commandFactory |

	settings := LanguageLinkSettings pharoDefaultSettings.
	settings 
		debugMode: true;
		serverSocketAddress: (LanguageLinkSocketAddress ipOrName: 'localhost' port: 7001).
	client := PharoLinkApplication newWith: settings.
	client start.

	commandFactory := client newCommandFactory.
	observer := commandFactory observerFromCallback: [ :anInteger | 
		anInteger seconds wait.
		true. ].
	observer setByValue.
	"register needs to keep request alive to keep observer alive"
	commandFactory sendAndWait: ('MyPharoLinkObserverTest addObserver: {1}' format:
			   { observer pharoLinkFormattedCode })
]

{ #category : #helper }
PharoLinkObserverTest >> addObserver: aBlock [
	"Register the supplied observer, signal that the test can continue and wait."

	observer := aBlock.
	observerProcess := Processor activeProcess.
	semaphore signal.
	Semaphore new wait.
]

{ #category : #helper }
PharoLinkObserverTest >> startClient [
	| command arguments |

	command := FileLocator vmBinary resolve fullName.
	arguments := { 
		FileLocator image resolve fullName.
		'eval'.
		'PharoLinkObserverTest connectAndRegisterObserver' }.
	clientProcess := GtSubprocessWithInMemoryOutput command: command arguments: arguments.
	clientProcess run.

]

{ #category : #helper }
PharoLinkObserverTest >> startServer [

	server := PharoLinkServer new
		listenPort: 7001;
		setDebugMode;
		start;
		closeOnExec: true;
		yourself.
	server globals at: #MyPharoLinkObserverTest put: self.

]

{ #category : #running }
PharoLinkObserverTest >> tearDown [

	server ifNotNil: [ server stop ].
	observerProcess ifNotNil: [ observerProcess terminate ].
	clientProcess ifNotNil: [ clientProcess terminate ].
	callbackProcess ifNotNil: [ callbackProcess terminate ].
	super tearDown.

]

{ #category : #tests }
PharoLinkObserverTest >> testObserverOnDisconnect [
	"Test that synchronous calls on an observer are signalled correctly when the connection is lost"
	| connectionLostSemaphore |

	semaphore := Semaphore new.
	connectionLostSemaphore := Semaphore new.
	self startServer.
	self startClient.

	"Wait for the client to start and observer to be registered"
	semaphore wait.

	"Start a process that has an active callback.
	Run at higher priority to ensure that it is waiting before we kill the client"
	callbackProcess := 
		[ [ observer value: 60 ] 
			on: PharoLinkServerConnectionLost
			do: [ :ex | connectionLostSemaphore signal. ] ]
				forkAt: Processor activeProcess priority + 1 
				named: 'PharoLinkObserverTest callback process'.

	"Kill the clientProcess, which will trigger the PharoLinkServerConnectionLost exception in the observer, signalling the connectionLostSemaphore"
	clientProcess kill.
	connectionLostSemaphore wait.

	"If execution gets to here the observer was signalled correctly."
	self assert: callbackProcess isTerminated.
	self deny: clientProcess isRunning.

]
