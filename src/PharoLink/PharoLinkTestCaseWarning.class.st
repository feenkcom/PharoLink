Class {
	#name : #PharoLinkTestCaseWarning,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseWarning >> addToResult: result [
	result addWarning: self
]

{ #category : #accessing }
PharoLinkTestCaseWarning >> color [

	^ Color orange
]

{ #category : #accessing }
PharoLinkTestCaseWarning >> shortName [

	^ #warning
]
