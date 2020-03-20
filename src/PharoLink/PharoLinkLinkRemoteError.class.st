Class {
	#name : #PharoLinkLinkRemoteError,
	#superclass : #Notification,
	#instVars : [
		'command',
		'errorMessage',
		'application',
		'proceedAction',
		'trace'
	],
	#category : #'PharoLink-ErrorHandling'
}

{ #category : #accessing }
PharoLinkLinkRemoteError >> application [
	^ application
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> command [
	^ command
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> command: anObject [
	command := anObject
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ self application settings platform uiManager spawnDebuggerOnException: self
]

{ #category : #'as yet unclassified' }
PharoLinkLinkRemoteError >> defaultProceedAction [
	^ JSLinkDropQueue new
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #initialization }
PharoLinkLinkRemoteError >> initialize [
	super initialize.
	proceedAction := self defaultProceedAction
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> isResumable [
	^ true
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> messageText [ 

	(messageText isNil or: [ messageText isEmpty ]) ifTrue: 
		[ ^ self trace asString ].
	^ super messageText
]

{ #category : #'as yet unclassified' }
PharoLinkLinkRemoteError >> messageTextFromError [

	errorMessage ifNil: [ ^'' ].
	errorMessage isDictionary ifFalse: [ ^'' ].
	^ String streamContents: [ :stream |
		errorMessage associations 
			do: [ :assoc | 
				stream 
					<< assoc key;
					<< ': ';
					print: assoc value ]
			separatedBy: 
				[ stream << ', ' ] ].
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> proceedAction [
	^ proceedAction
]

{ #category : #accessing }
PharoLinkLinkRemoteError >> proceedAction: anObject [
	proceedAction := anObject
]

{ #category : #tracing }
PharoLinkLinkRemoteError >> trace [
	^ trace
]

{ #category : #tracing }
PharoLinkLinkRemoteError >> trace: aTrace [
	trace := aTrace
]
