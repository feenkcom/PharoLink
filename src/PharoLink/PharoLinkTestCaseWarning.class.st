Class {
	#name : #PharoLinkTestCaseWarning,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseWarning class >> leJsonV4Name [

	^ #pharoLinkTestCaseWarning
]

{ #category : #accessing }
PharoLinkTestCaseWarning >> addToTestResult: result [
	result addWarning: self asTestCase
]

{ #category : #accessing }
PharoLinkTestCaseWarning >> color [

	^ Color orange
]

{ #category : #'as yet unclassified' }
PharoLinkTestCaseWarning >> populateTestResult: aTestResult with: aTestCase [

	testCaseShouldPass
		ifTrue: [ aTestResult addError: aTestCase ]
		ifFalse: [ aTestResult addPass: aTestCase ].

]

{ #category : #accessing }
PharoLinkTestCaseWarning >> shortName [

	^ #warning
]
