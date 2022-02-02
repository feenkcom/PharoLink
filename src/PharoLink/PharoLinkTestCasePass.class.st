Class {
	#name : #PharoLinkTestCasePass,
	#superclass : #PharoLinkTestCaseEndAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCasePass class >> leJsonV4Name [

	^ #pharoLinkTestCasePass
]

{ #category : #accessing }
PharoLinkTestCasePass >> addToResult: result [
	result addPass: self
]

{ #category : #accessing }
PharoLinkTestCasePass >> color [

	^ Color green
]

{ #category : #'as yet unclassified' }
PharoLinkTestCasePass >> populateTestResult: aTestResult with: aTestCase [

	aTestResult addPass: aTestCase
]

{ #category : #accessing }
PharoLinkTestCasePass >> shortName [

	^ #pass
]
