Class {
	#name : #PharoLinkTestCaseEndAnnouncement,
	#superclass : #PharoLinkTestCaseAnnouncement,
	#instVars : [
		'testCaseShouldPass',
		'testCaseStartTimestamp'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement class >> isAbstract [

	^ self == PharoLinkTestCaseEndAnnouncement
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement class >> leFromJsonV4Dictionary: aDictionary [

	^ (super leFromJsonV4Dictionary: aDictionary)
		  initializeShouldPass: (aDictionary at: #testCaseShouldPass)
		  startTimestamp: (aDictionary at: #testCaseStartTimestamp);
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement class >> leJsonV4AddMappingsTo: aJsonMapping [

	super leJsonV4AddMappingsTo: aJsonMapping.
	aJsonMapping
		mapProperty: #testCaseShouldPass
		getter: [ :object | object shouldPass ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #testCaseStartTimestamp
		getter: [ :object | object testCaseStartTimestamp ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ]
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement class >> testCase: aTestCase startTimestamp: aDateAndTime [

	^ (super testCase: aTestCase)
		  initializeShouldPass: aTestCase shouldPass
		  startTimestamp: aDateAndTime;
		  yourself
]

{ #category : #ui }
PharoLinkTestCaseEndAnnouncement >> gtTestCaseFor: aView [

	<gtView>
	^ aView forward
		  title: 'Test case';
		  priority: 10;
		  object: [ testCaseClass lookupSelector: testCaseSelector ];
		  view: #gtSourceFor:
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> initializeShouldPass: aBoolean startTimestamp: aDateAndTime [

	testCaseShouldPass := aBoolean.
	testCaseStartTimestamp := aDateAndTime
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> isEnd [

	^ true
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> shouldPass [

	^ testCaseShouldPass
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> testCaseStartTimestamp [

	^ testCaseStartTimestamp
]
