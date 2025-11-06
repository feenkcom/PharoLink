Class {
	#name : #PharoLinkApplicationTestResource,
	#superclass : #TestResource,
	#instVars : [
		'application',
		'commandFactory',
		'process'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #initialization }
PharoLinkApplicationTestResource >> application [
	^ application
]

{ #category : #accessing }
PharoLinkApplicationTestResource >> commandFactory [
	^ commandFactory
]

{ #category : #running }
PharoLinkApplicationTestResource >> setUp [
	"Start a PharoLink server that will automatically exit once the test is complete"
	| settings args port |

	super setUp.

	settings := LanguageLinkSettings pharoDefaultSettings.
	port := PharoLinkPortAllocator next.

	args := OrderedCollection new.
	args
		add: settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkServer';
		add: '--oneShot';
		add: '--log';
		add: port asString;
		add: '--detachChangesFromFileSystem';
		add: '--epiceaMemoryStore';
		add: '--noGtImageUpdate'.
	process := GtSubprocessWithInMemoryOutput new
		command: settings serverExecutable fullName;
		arguments: args;
		terminateOnShutdown;
		yourself.
	process run.

	settings
		serverProcessClass: LanguageLinkManualProcess;
		serverSocketAddress: (LanguageLinkSocketAddress
				ipOrName: 'localhost'
				port: port).
	application := PharoLinkApplication newWith: settings.
	application settings debugMode: true.
	application start.
	commandFactory := application newCommandFactory.

]

{ #category : #running }
PharoLinkApplicationTestResource >> tearDown [

	application stop.
	"Closing the application should have been enough to cause the server to exit.
	But just in case..."
	process kill.
	super tearDown.
]
