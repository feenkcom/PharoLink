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

{ #category : #accessing }
PharoLinkTestCaseWarning >> shortName [

	^ #warning
]
