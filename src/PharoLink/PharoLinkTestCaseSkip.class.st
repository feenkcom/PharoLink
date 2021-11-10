Class {
	#name : #PharoLinkTestCaseSkip,
	#superclass : #PharoLinkTestCaseExceptionAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseSkip >> addToResult: result [
	result addSkip: self
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> color [

	^ Color gray
]

{ #category : #accessing }
PharoLinkTestCaseSkip >> shortName [

	^ #skip
]
