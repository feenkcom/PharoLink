Extension { #name : #TestFailure }

{ #category : #'*PharoLink' }
TestFailure >> gtTestCaseException: aTestCase [

	^ PharoLinkTestCaseFailure testCase: aTestCase exception: self
]
