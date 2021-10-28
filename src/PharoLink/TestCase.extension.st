Extension { #name : #TestCase }

{ #category : #'*PharoLink' }
TestCase >> gtTestCasePass [

	^ PharoLinkTestCasePass testCase: self
]

{ #category : #'*PharoLink' }
TestCase >> gtTestCaseStart [

	^ PharoLinkTestCaseStart testCase: self
]
