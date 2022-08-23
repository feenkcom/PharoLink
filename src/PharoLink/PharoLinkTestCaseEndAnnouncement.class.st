Class {
	#name : #PharoLinkTestCaseEndAnnouncement,
	#superclass : #PharoLinkTestCaseAnnouncement,
	#instVars : [
		'testCaseShouldPass',
		'testCaseEndTimestamp'
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
		shouldPass: (aDictionary at: #testCaseShouldPass);
		testCaseEndTimestamp: (aDictionary at: #testCaseEndTimestamp);
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
		mapProperty: #testCaseEndTimestamp
			getter: [ :object | object testCaseEndTimestamp ]
			setter: [ :object :value | 
				self error: 'Cannot set it, use leFromJsonV4Dictionary' ]

]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement class >> testCase: aTestCase startTimestamp: aDateAndTime [

	^ (super testCase: aTestCase)
		initializeShouldPass: aTestCase shouldPass
			startTimestamp: aDateAndTime
			endTimestamp: DateAndTime now;
		yourself
]

{ #category : #adding }
PharoLinkTestCaseEndAnnouncement >> addToTestResult: aTestResult [

	self subclassResponsibility
]

{ #category : #converting }
PharoLinkTestCaseEndAnnouncement >> asTestResult [
	"Answer a TestResult matching the receiver"
	| result |

	result := TestResult new.
	result timeStamp: testCaseEndTimestamp.
	self addToTestResult: result.
	^ result
		
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> duration [
	"Answer the duration (execution time) of the receiver"
	<return: #Duration or: nil>

	(testCaseStartTimestamp isNil or: [ testCaseEndTimestamp isNil ]) ifTrue: [ ^ nil ].

	^ testCaseEndTimestamp - testCaseStartTimestamp.

]

{ #category : #ui }
PharoLinkTestCaseEndAnnouncement >> gtTestCaseFor: aView [

	<gtView>
	^ aView forward
		  title: 'Test case';
		  priority: 10;
		  object: [ (self class environment at: testCaseClassName asSymbol) lookupSelector: testCaseSelector ];
		  view: #gtSourceFor:
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> initializeShouldPass: aBoolean startTimestamp: startDateAndTime endTimestamp: endDateAndTime [

	testCaseShouldPass := aBoolean.
	testCaseStartTimestamp := startDateAndTime.
	testCaseEndTimestamp := endDateAndTime.
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> isEnd [

	^ true
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> shouldPass [

	^ testCaseShouldPass
]

{ #category : #private }
PharoLinkTestCaseEndAnnouncement >> shouldPass: aBoolean [

	testCaseShouldPass := aBoolean
]

{ #category : #ui }
PharoLinkTestCaseEndAnnouncement >> summaryAttributes [
	"Answer a collection of key/value attributes that can simply be listed as a summary of the receiver"
	| attributes duration|

	attributes := super summaryAttributes.
	duration := self duration.
	attributes
		add: 'End Time:' -> testCaseEndTimestamp;
		add: 'Should Pass:' -> testCaseShouldPass.
	duration ifNotNil:
		[ attributes add: 'Duration:' -> duration ].
	^ attributes
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> testCaseEndTimestamp [

	^ testCaseEndTimestamp
]

{ #category : #private }
PharoLinkTestCaseEndAnnouncement >> testCaseEndTimestamp: anObject [

	testCaseEndTimestamp := anObject
]
