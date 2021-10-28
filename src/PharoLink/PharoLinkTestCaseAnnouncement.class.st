Class {
	#name : #PharoLinkTestCaseAnnouncement,
	#superclass : #PharoLinkTestAnnouncement,
	#instVars : [
		'testCaseClass',
		'testCaseIdentityHash',
		'testCaseSelector'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseAnnouncement class >> testCase: aTestCase [

	^ self new
		  initializeTestCaseClass: aTestCase class
		  selector: aTestCase selector
		  identityHash: aTestCase identityHash;
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> = anObject [

	anObject == self ifTrue: [ ^ true ].
	anObject class = self class ifFalse: [ ^ false ].
	testCaseIdentityHash = anObject testCaseIdentityHash ifFalse: [ 
		^ false ].
	^ true
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> hash [

	^ testCaseIdentityHash
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> initializeTestCaseClass: aClass selector: aSelector identityHash: anInteger [

	testCaseClass := aClass.
	testCaseSelector := aSelector.
	testCaseIdentityHash := anInteger
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> isEnd [

	self subclassResponsibility
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> printOn: aStream [

	aStream
		nextPutAll: self shortName;
		nextPut: Character space;
		nextPutAll: testCaseClass name;
		nextPutAll: '>>#';
		nextPutAll: testCaseSelector
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> shortName [

	self subclassResponsibility
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseClass [

	^ testCaseClass
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseIdentityHash [

	^ testCaseIdentityHash
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseSelector [

	^ testCaseSelector
]
