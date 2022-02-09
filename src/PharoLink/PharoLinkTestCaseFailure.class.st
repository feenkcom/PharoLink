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

{ #category : #accessing }
PharoLinkTestCaseFailure >> shortName [

	^ #failure
]
