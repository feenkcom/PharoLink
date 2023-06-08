Extension { #name : #Deprecation }

{ #category : #'*PharoLink' }
Deprecation >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseWarning
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]
