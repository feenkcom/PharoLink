Extension { #name : #TestSkipped }

{ #category : #'*PharoLink' }
TestSkipped >> gtTestCaseException: aTestCase [

	^ PharoLinkTestCaseSkip testCase: aTestCase exception: self
]
