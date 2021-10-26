Extension { #name : #Error }

{ #category : #'*PharoLink' }
Error >> gtTestCaseException: aTestCase [

	^ PharoLinkTestCaseError testCase: aTestCase exception: self
]
