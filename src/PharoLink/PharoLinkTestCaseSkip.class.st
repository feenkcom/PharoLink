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
PharoLinkTestCaseSkip >> addToResult: result [
	result addSkip: self
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> color [

	^ Color gray
]

{ #category : #'as yet unclassified' }
PharoLinkTestCaseSkip >> populateTestResult: aTestResult with: aTestCase [

	aTestResult addSkip: aTestCase.
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> shortName [

	^ #skip
]
