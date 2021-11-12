Class {
	#name : #PharoLinkTestCaseError,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseError >> addToResult: result [
	result addError: self
]

{ #category : #accessing }
PharoLinkTestCaseError >> color [

	^ Color red
]

{ #category : #accessing }
PharoLinkTestCaseError >> shortName [

	^ #error
]
