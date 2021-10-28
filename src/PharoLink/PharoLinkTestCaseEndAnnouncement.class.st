Class {
	#name : #PharoLinkTestCaseEndAnnouncement,
	#superclass : #PharoLinkTestCaseAnnouncement,
	#instVars : [
		'testCaseShouldPass'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement class >> testCase: aTestCase [

	^ (super testCase: aTestCase)
		  initializeShouldPass: aTestCase shouldPass;
		  yourself
]

{ #category : #ui }
PharoLinkTestCaseEndAnnouncement >> gtTestCaseFor: aView [

	<gtView>
	^ aView forward
		  title: 'Test case';
		  priority: 10;
		  object: [ testCaseClass >> testCaseSelector ];
		  view: #gtSourceFor:
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> initializeShouldPass: aBoolean [

	testCaseShouldPass := aBoolean
]

{ #category : #accessing }
PharoLinkTestCaseEndAnnouncement >> isEnd [

	^ true
]
