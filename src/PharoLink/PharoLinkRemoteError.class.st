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

{ #category : #private }
PharoLinkRemoteError >> defaultProceedAction [
	^ LanguageLinkDropQueue new
]

{ #category : #accessing }
PharoLinkRemoteError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
PharoLinkRemoteError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #ui }
PharoLinkRemoteError >> formattedText: aString [
	| fullText regex |

	fullText := aString asRopedText.
	"The regex also groups the line and column numbers.
	ToDo: open the file with the error line number highlighted"
	regex := '\s*at\s[^(]*\(([^:(]+)\:(\d+)\:(\d+)\)' asRegex.
	regex matchesIn: aString do: [ :match | | filename filenameStart filenameEnd |
		filenameStart := (regex subBeginning: 2) first asNumber + 1.
		filenameEnd := (regex subBeginning: 3) first asNumber - 1.
		filename := fullText from: filenameStart to: filenameEnd.
		filename foreground: GtDocumentConstants linkColor.
		filename attribute: (BrTextClickAttribute new 
			action: [ :text :textElement :textEditor :clickEvent |
				textElement phlow spawnObject: filename asString asFileReference ])
		 ].
	^ fullText
]

{ #category : #ui }
PharoLinkRemoteError >> gtMessageTextFor: aView [
	"<gtView>"

	^ aView textEditor
		title: 'Message';
		priority: 2;
		text: [ self formattedText: self messageText ]
]

{ #category : #ui }
PharoLinkRemoteError >> gtTraceTextFor: aView [
	<gtView>

	(messageText isNil or: [ messageText isEmpty ]) ifTrue: 
		[ ^ aView empty ].
	^ aView textEditor
		title: 'Trace';
		priority: 2;
		text: [ self formattedText: self trace asString ]
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
