Class {
	#name : #PharoLinkTestCaseFailure,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseFailure class >> leJsonV4Name [

	^ #pharoLinkTestCaseFailure
]

{ #category : #accessing }
PharoLinkTestCaseFailure >> addToTestResult: result [
	result addFailure: self asTestCase
]

{ #category : #accessing }
PharoLinkTestCaseFailure >> color [

	^ Color yellow
]

{ #category : #'as yet unclassified' }
PharoLinkTestCaseFailure >> populateTestResult: aTestResult with: aTestCase [

	testCaseShouldPass
		ifTrue: [ aTestResult addFailure: aTestCase ]
		ifFalse: [ aTestResult addPass: aTestCase ].

]

{ #category : #accessing }
PharoLinkTestCaseFailure >> shortName [

	^ #failure
]
