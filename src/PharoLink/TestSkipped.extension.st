Extension { #name : #TestSkipped }

{ #category : #'*PharoLink' }
TestSkipped >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseSkip
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]

{ #category : #'*PharoLink' }
TestSkipped >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime additionalData:  additionalData [

	^ PharoLinkTestCaseSkip
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
		  additionalData:  additionalData
]
