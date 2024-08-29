Extension { #name : #Deprecation }

{ #category : #'*PharoLink' }
Deprecation >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime [

	^ PharoLinkTestCaseWarning
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
]

{ #category : #'*PharoLink' }
Deprecation >> gtTestCaseException: aTestCase startTimestamp: aDateAndTime additionalData:  additionalData [

	^ PharoLinkTestCaseWarning
		  testCase: aTestCase
		  startTimestamp: aDateAndTime
		  exception: self
		  additionalData:  additionalData
]
