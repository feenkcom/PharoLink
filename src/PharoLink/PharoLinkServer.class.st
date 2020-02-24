Class {
	#name : #PharoLinkServer,
	#superclass : #Object,
	#instVars : [
		'listenPort',
		'responsePort',
		'znServer',
		'debugMode'
	],
	#category : #'PharoLink-Server'
}

{ #category : #accessing }
PharoLinkServer >> debugMode [
	^ debugMode
]

{ #category : #private }
PharoLinkServer >> handlEnqueue: aZnRequest [
	"Process the supplied statements"
	| command dict |

	dict := JSLinkNeoJsonSerializer new deserialize: aZnRequest entity contents.
	command := PharoLinkEvalCommand
					source: (dict at: #'statements')
					bindings: (dict at: #'bindings')
					id: (dict at: #'commandId').
	command responsePort: self responsePort.
	[ command execute: { } ] forkAt: Processor userBackgroundPriority.
	^ (ZnResponse statusLine: ZnStatusLine ok)
		entity: (ZnEntity json: '{}');
		yourself
]

{ #category : #private }
PharoLinkServer >> handleIsAlive: aZnRequest [
	"Respond to the ping request"

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
	debugMode := false.
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
