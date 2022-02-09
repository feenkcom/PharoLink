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
PharoLinkTestCaseSkip >> color [

	^ Color gray
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> shortName [

	^ #skip
]
