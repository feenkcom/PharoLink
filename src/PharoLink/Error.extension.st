Extension { #name : #Error }

{ #category : #'*PharoLink' }
Error >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseError
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]
