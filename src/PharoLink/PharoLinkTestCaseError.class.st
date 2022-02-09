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
PharoLinkTestCaseError >> color [

	^ Color red
]

{ #category : #accessing }
PharoLinkTestCaseError >> shortName [

	^ #error
]
