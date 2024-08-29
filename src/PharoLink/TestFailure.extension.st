Extension { #name : #TestFailure }

{ #category : #'*PharoLink' }
TestFailure >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseFailure
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]

{ #category : #'*PharoLink' }
TestFailure >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime additionalData:  additionalData [

	^ PharoLinkTestCaseFailure
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
		  additionalData:  additionalData
]
