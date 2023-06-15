Class {
	#name : #PharoLinkTestCaseSkip,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseSkip class >> leJsonV4Name [

	^ #pharoLinkTestCaseSkip
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> addToTestResult: result [
	result addSkip: self asTestCase
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> asGtExampleResult [
	"Answer the receiver wrapped in the appropriate GtExampleResultX class."

	^ GtExampleResultNoValue new.
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> color [

	^ Color gray
]

{ #category : #testing }
PharoLinkTestCaseSkip >> isSkipped [

	^ true
]

{ #category : #'as yet unclassified' }
PharoLinkTestCaseSkip >> populateTestResult: aTestResult with: aTestCase [

	aTestResult addSkip: aTestCase.
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> shortName [

	^ #skip
]
