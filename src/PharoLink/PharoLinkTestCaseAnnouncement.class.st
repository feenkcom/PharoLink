Class {
	#name : #PharoLinkTestCaseAnnouncement,
	#superclass : #PharoLinkTestAnnouncement,
	#instVars : [
		'testCaseClass',
		'testCaseIdentityHash',
		'testCaseSelector',
		'testCaseStartTimestamp'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseAnnouncement class >> isAbstract [

	^ self == PharoLinkTestCaseAnnouncement
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement class >> leFromJsonV4Dictionary: aDictionary [

	^ self new
		initializeTestCaseClass: (aDictionary at: #testCaseClass) asClass
			selector: (aDictionary at: #testCaseSelector) asSymbol
			identityHash: (aDictionary at: #testCaseIdentityHash);
		testCaseStartTimestamp: (aDictionary at: #testCaseStartTimestamp); 
		yourself
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement class >> leJsonV4AddMappingsTo: aJsonMapping [

	aJsonMapping
		mapProperty: #testCaseClass
			getter: [ :object | object testCaseClass name ]
			setter: [ :object :value | 
				self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #testCaseIdentityHash
			getter: [ :object | object testCaseIdentityHash ]
			setter: [ :object :value | 
				self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #testCaseSelector
			getter: [ :object | object testCaseSelector ]
			setter: [ :object :value | 
				self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #testCaseStartTimestamp
			getter: [ :object | object testCaseStartTimestamp ]
			setter: [ :object :value | 
				self error: 'Cannot set it, use leFromJsonV4Dictionary' ]

]

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
PharoLinkTestCaseAnnouncement >> asTestCase [
	"Answer a test case matching the receiver"

	^ testCaseClass selector: testCaseSelector
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
PharoLinkTestCaseAnnouncement >> method [
	^ self asTestCase gtCompiledMethod
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

{ #category : #ui }
PharoLinkTestCaseAnnouncement >> summaryAttributes [
	"Answer a collection of key/value attributes that can simply be listed as a summary of the receiver"
	| method |

	method := String streamContents: [ :stream |
		stream
			<< (testCaseClass
				ifNil: [ '<None>' ]
				ifNotNil: [ testCaseClass name ]);
			<< '>>';
			<< (testCaseSelector
				ifNil: [ '<None>' ]
				ifNotNil: [ testCaseSelector ]) ].
	^ OrderedCollection new
		add: 'Method:' -> method;
		add: 'Start Time:' -> testCaseStartTimestamp;
		yourself.
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseClass [

	^ self class environment at: testCaseClassName asSymbol.
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseIdentityHash [

	^ testCaseIdentityHash
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseSelector [

	^ testCaseSelector
]

{ #category : #accessing }
PharoLinkTestCaseAnnouncement >> testCaseStartTimestamp [

	^ testCaseStartTimestamp
]

{ #category : #private }
PharoLinkTestCaseAnnouncement >> testCaseStartTimestamp: anObject [

	testCaseStartTimestamp := anObject
]
