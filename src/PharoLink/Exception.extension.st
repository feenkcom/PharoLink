Extension { #name : #Exception }

{ #category : #'*PharoLink' }
Exception >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseError
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]

{ #category : #'*PharoLink' }
Exception >> isPharoLinkNotification [
	"Answer a boolean indicating whether this exception is a PharoLink notification"

	^ false
]

{ #category : #'*PharoLink' }
Exception >> pharoLinkAdditionalData [
	^  nil
]

{ #category : #'*PharoLink' }
Exception >> stackString [

	signalContext ifNil: [ ^ '' ].
	^ String streamContents: [ :stream | 
		  signalContext stack do: [ :stackItem | 
			  stream
				  print: stackItem;
				  cr ] ]
]
