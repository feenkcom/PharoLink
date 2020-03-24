Class {
	#name : #PharoLinkRemoteError,
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
PharoLinkRemoteError >> application [
	^ application
]

{ #category : #accessing }
PharoLinkRemoteError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PharoLinkRemoteError >> command [
	^ command
]

{ #category : #accessing }
PharoLinkRemoteError >> command: anObject [
	command := anObject
]

{ #category : #accessing }
PharoLinkRemoteError >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ self application settings platform uiManager spawnDebuggerOnException: self
]

{ #category : #'as yet unclassified' }
PharoLinkRemoteError >> defaultProceedAction [
	^ JSLinkDropQueue new
]

{ #category : #accessing }
PharoLinkRemoteError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
PharoLinkRemoteError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #initialization }
PharoLinkRemoteError >> initialize [
	super initialize.
	proceedAction := self defaultProceedAction
]

{ #category : #accessing }
PharoLinkRemoteError >> isResumable [
	^ true
]

{ #category : #accessing }
PharoLinkRemoteError >> messageText [ 

	(messageText isNil or: [ messageText isEmpty ]) ifTrue: 
		[ ^ self trace asString ].
	^ super messageText
]

{ #category : #'as yet unclassified' }
PharoLinkRemoteError >> messageTextFromError [

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
PharoLinkRemoteError >> proceedAction [
	^ proceedAction
]

{ #category : #accessing }
PharoLinkRemoteError >> proceedAction: anObject [
	proceedAction := anObject
]

{ #category : #tracing }
PharoLinkRemoteError >> trace [
	^ trace
]

{ #category : #tracing }
PharoLinkRemoteError >> trace: aTrace [
	trace := aTrace
]
