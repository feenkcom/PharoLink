Extension { #name : #TestSkipped }

{ #category : #'*PharoLink' }
TestSkipped >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseSkip
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]
