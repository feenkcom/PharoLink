Class {
	#name : #PharoLinkTestCaseExceptionAnnouncement,
	#superclass : #PharoLinkTestCaseEndAnnouncement,
	#instVars : [
		'exceptionClass',
		'exceptionMessageText',
		'exceptionTrace'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #testing }
PharoLinkTestCaseExceptionAnnouncement class >> isAbstract [

	^ self == PharoLinkTestCaseExceptionAnnouncement
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> leFromJsonV4Dictionary: aDictionary [

	^ (super leFromJsonV4Dictionary: aDictionary)
		  initializeExceptionClass: (aDictionary 
		  	at: #exceptionClass
		  	ifPresent: #asClass
		  	ifAbsent: [])
		  messageText: (aDictionary at: #exceptionMessageText ifAbsent: [])
		  trace: (aDictionary at: #exceptionTrace ifAbsent: []);
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> leJsonV4AddMappingsTo: aJsonMapping [

	super leJsonV4AddMappingsTo: aJsonMapping.
	aJsonMapping
		mapProperty: #exceptionClass
		getter: [ :object | object exceptionClass ifNotNil: #name ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #exceptionMessageText
		getter: [ :object | object exceptionMessageText ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #exceptionTrace
		getter: [ :object | object exceptionTrace ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> testCase: aTestCase startTimestamp: aDateAndTime exception: anException [

	^ (self testCase: aTestCase startTimestamp: aDateAndTime)
		  initializeExceptionClass: anException class
		  messageText: anException messageText
		  trace: anException stackString;
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionClass [

	^ exceptionClass
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionMessageText [

	^ exceptionMessageText
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionTrace [

	^ exceptionTrace
]

{ #category : #ui }
PharoLinkTestCaseExceptionAnnouncement >> gtTraceFor: aView [
	<gtView>

	exceptionTrace ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Trace';
		priority: 15;
		text: [ exceptionTrace ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> initializeExceptionClass: aClass messageText: aString trace: anotherString [

	exceptionClass := aClass.
	exceptionMessageText := aString.
	exceptionTrace := anotherString
]

{ #category : #'as yet unclassified' }
PharoLinkTestCaseExceptionAnnouncement >> populateTestResult: aTestResult with: aTestCase [

	^ self subclassResponsibility 
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPut: Character space;
		nextPutAll: (exceptionClass 
			ifNil: [ '<unknown>' ]
			ifNotNil: [ exceptionClass name ]);
		nextPut: Character space;
		nextPutAll: (exceptionMessageText
			ifNil: [ '<none>' ]
			ifNotNil: [ exceptionMessageText ])
]

{ #category : #ui }
PharoLinkTestCaseExceptionAnnouncement >> summaryAttributes [
	"Answer a collection of key/value attributes that can simply be listed as a summary of the receiver"

	^ super summaryAttributes
		add: 'Exception Class:' -> exceptionClass;
		add: 'Message:' -> exceptionMessageText;
		yourself.
]
