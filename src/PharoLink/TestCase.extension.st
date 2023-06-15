Extension { #name : #TestCase }

{ #category : #'*PharoLink' }
TestCase >> gtTestCasePassStartTimestamp: aDateAndTime [

	^ PharoLinkTestCasePass testCase: self startTimestamp: aDateAndTime
]

{ #category : #'*PharoLink' }
TestCase >> gtTestCaseStart [

	^ PharoLinkTestCaseStart testCase: self
]
