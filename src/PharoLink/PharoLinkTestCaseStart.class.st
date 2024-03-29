Class {
	#name : #PharoLinkTestCaseStart,
	#superclass : #PharoLinkTestCaseAnnouncement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseStart class >> leJsonV4Name [

	^ #pharoLinkTestCaseStart
]

{ #category : #accessing }
PharoLinkTestCaseStart >> addToTestResult: result [

	
]

{ #category : #accessing }
PharoLinkTestCaseStart >> color [

	^ Color blue
]

{ #category : #initialization }
PharoLinkTestCaseStart >> initialize [

	super initialize.
	testCaseStartTimestamp := DateAndTime now.
]

{ #category : #accessing }
PharoLinkTestCaseStart >> isEnd [

	^ false
]

{ #category : #accessing }
PharoLinkTestCaseStart >> shortName [

	^ #start
]

{ #category : #accessing }
PharoLinkTestCaseStart >> timestamp [

	^ testCaseStartTimestamp 
]
