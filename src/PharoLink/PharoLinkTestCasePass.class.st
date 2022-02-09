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
PharoLinkTestCasePass >> addToTestResult: result [
	result addPass: self asTestCase
]

{ #category : #accessing }
PharoLinkTestCasePass >> color [

	^ Color green
]

{ #category : #accessing }
PharoLinkTestCasePass >> shortName [

	^ #pass
]
