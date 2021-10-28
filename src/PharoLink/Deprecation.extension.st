Extension { #name : #Deprecation }

{ #category : #'*PharoLink' }
Deprecation >> gtTestCaseException: aTestCase [

	^ PharoLinkTestCaseWarning testCase: aTestCase exception: self
]
