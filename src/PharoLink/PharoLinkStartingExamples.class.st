Class {
	#name : #PharoLinkStartingExamples,
	#superclass : #Object,
	#instVars : [
		'server',
		'application'
	],
	#category : 'PharoLink-Examples'
}

{ #category : #accessing }
PharoLinkStartingExamples >> application [
	^ application
]

{ #category : #'in image' }
PharoLinkStartingExamples >> checkPidInImage [
	"Ask for the vm PID in the client and server.
	As this is in image, they should be the same"
	<gtExample>
	<after: #shutdownServer>
	<noTest>
	| clientPID serverPID |

	self inImageClient.
	clientPID := LibC uniqueInstance currentProcessId.
	serverPID := application newCommandFactory
		<< 'LibC uniqueInstance currentProcessId';
		sendAndWait.
	self assert: clientPID = serverPID.
	^ serverPID
]

{ #category : #'in image' }
PharoLinkStartingExamples >> checkPidRemoteImage [
	"Ask for the vm PID in the client and server.
	As this is a remote image, they should be different"
	<gtExample>
	<after: #shutdownServer>
	<noTest>
	| clientPID serverPID |

	self remoteImageClient.
	clientPID := LibC uniqueInstance currentProcessId.
	serverPID := application newCommandFactory
		<< 'LibC uniqueInstance currentProcessId';
		sendAndWait.
	self assert: clientPID ~= serverPID.
	^ { clientPID. serverPID. }
]

{ #category : #'in image' }
PharoLinkStartingExamples >> inImageClient [
	"Answer a client configure to use the in image server"
	| settings |

	self inImageServer.
	settings := LanguageLinkSettings pharoDefaultSettings
		clientSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: 7099);
		serverSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: 6999);
		serverProcessClass: LanguageLinkManualProcess;
		debugMode: true;
		yourself.
	application := PharoLinkApplication newWith: settings.
	application start.
	^ application
]

{ #category : #'in image' }
PharoLinkStartingExamples >> inImageServer [
	"Start a server running in this image"

	server := PharoLinkServer new 
		setDebugMode;
		listenPort: 6999;
		responsePort: 7099;
		start.
	self assert: server isRunning.
	^ server
]

{ #category : #'remote image' }
PharoLinkStartingExamples >> remoteImageClient [
	"Answer a client configure to use a remote image server (which is automatically started)"
	| settings |

	settings := LanguageLinkSettings pharoDefaultSettings
		debugMode: true;
		yourself.
	application := PharoLinkApplication newWith: settings.
	application start.
	^ application
]

{ #category : #accessing }
PharoLinkStartingExamples >> server [
	^ server
]

{ #category : #private }
PharoLinkStartingExamples >> shutdownServer [
	"Shut down the running server"

	server ifNotNil: [ server stop ].
	application ifNotNil: [ application stop ].
	server := nil.
	application := nil.
	^self
]
