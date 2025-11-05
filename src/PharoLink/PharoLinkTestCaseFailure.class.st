Class {
	#name : #PharoLinkTestCaseFailure,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : 'PharoLink-Test-Runner'
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
PharoLinkTestCaseFailure >> asGtExampleResult [
	"Answer the receiver wrapped in the appropriate GtExampleResultX class."

	^ GtExampleResultFailureValue new failure: (GtRrErrorDetails new
		errorMessage: exceptionMessageText;
		trace: exceptionTrace).
]

{ #category : #accessing }
PharoLinkTestCaseFailure >> color [

	^ Color yellow
]

{ #category : #accessing }
PharoLinkTestCaseFailure >> gtAdditionalExceptionsFor: aView [
	<gtView>

	(additionalExceptions isNil or: [ additionalExceptions isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView list
		title: 'Additional Exceptions';
		priority: 40;
		items: [ additionalExceptions ]
]

{ #category : #testing }
PharoLinkTestCaseFailure >> isFailure [

	^ true
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
