Class {
	#name : #PharoLinkTestCaseStart,
	#superclass : #PharoLinkTestCaseAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseStart >> color [

	^ Color blue
]

{ #category : #accessing }
PharoLinkTestCaseStart >> isEnd [

	^ false
]

{ #category : #accessing }
PharoLinkTestCaseStart >> shortName [

	^ #start
]
