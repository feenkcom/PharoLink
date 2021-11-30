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
PharoLinkTestCaseFailure >> addToResult: result [
	result addFailure: self
]

{ #category : #accessing }
PharoLinkTestCaseFailure >> color [

	^ Color yellow
]

{ #category : #accessing }
PharoLinkTestCaseFailure >> shortName [

	^ #failure
]
