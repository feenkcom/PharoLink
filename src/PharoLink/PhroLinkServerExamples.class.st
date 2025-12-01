Class {
	#name : #PhroLinkServerExamples,
	#superclass : #Object,
	#instVars : [
		'server',
		'application'
	],
	#category : 'PharoLink-Tests'
}

{ #category : #'as yet unclassified' }
PhroLinkServerExamples >> invalidRegistryId [
	"Check that the server handles requests of an object with an invalid id correctly"
	<gtExample>
	<after: #tidyUp>
	| invalidObject result promise |
	
	server := self newRunningServer.
	application := self newConnectedApplication.
	invalidObject := PharoLinkProxyObject
		remoteClass: 'Object'
		name: 'notinregistry'
		application: application.
	promise := application newCommandFactory
		bindingAt: #proxyObject put: invalidObject;
		<< 'proxyObject';
		sendCommand.
	[ [ result := promise
		timeout: 5 seconds;
		waitForValue ]
			on: TimedOut
			do: [ AssertionFailure signal: 'Server failed to respond' ] ]
				on: PharoLinkRemoteError
				do: [ :ex |
					self assert: (ex errorMessage beginsWith: 'PharoLinkRegistryUnknownObjectError') ].
]

{ #category : #private }
PhroLinkServerExamples >> newConnectedApplication [
	| settings app |

	settings := LanguageLinkSettings pharoDefaultSettings.
	settings 
		serverProcessClass: LanguageLinkManualProcess;
		serverSocketAddress: (LanguageLinkSocketAddress from: 'localhost:', server listenPort asString).
	app := PharoLinkApplication newWith: settings.
	app start.
	^ app
]

{ #category : #private }
PhroLinkServerExamples >> newRunningServer [

	^ PharoLinkServer new 
		listenPort: 0;
		start
]

{ #category : #'as yet unclassified' }
PhroLinkServerExamples >> tidyUp [

	application ifNotNil: #stop.
	application := nil.
	server ifNotNil: #stop.
	server := nil.
]
