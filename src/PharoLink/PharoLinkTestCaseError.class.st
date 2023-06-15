Class {
	#name : #PharoLinkTestCaseError,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseError class >> leJsonV4Name [

	^ #pharoLinkTestCaseError
]

{ #category : #accessing }
PharoLinkTestCaseError >> addToTestResult: result [

	result addError: self asTestCase
]

{ #category : #accessing }
PharoLinkTestCaseError >> asGtExampleResult [
	"Answer the receiver wrapped in the appropriate GtExampleResultX class."

	^ GtExampleResultErrorValue new exception: (GtRrErrorDetails new
		errorMessage: exceptionMessageText;
		trace: exceptionTrace).
]

{ #category : #accessing }
PharoLinkTestCaseError >> color [

	^ Color red
]

{ #category : #testing }
PharoLinkTestCaseError >> isError [

	^ true
]

{ #category : #'as yet unclassified' }
PharoLinkTestCaseError >> populateTestResult: aTestResult with: aTestCase [

	testCaseShouldPass
		ifTrue: [ aTestResult addError: aTestCase ]
		ifFalse: [ aTestResult addPass: aTestCase ].

]

{ #category : #accessing }
PharoLinkTestCaseError >> shortName [

	^ #error
]
