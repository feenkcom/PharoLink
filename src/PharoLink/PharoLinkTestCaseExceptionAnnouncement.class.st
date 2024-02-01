Class {
	#name : #PharoLinkTestCaseExceptionAnnouncement,
	#superclass : #PharoLinkTestCaseEndAnnouncement,
	#instVars : [
		'additionalExceptions',
		'primaryException'
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
		  trace: (aDictionary at: #exceptionTrace ifAbsent: [])
		  additionalData: (aDictionary at: #exceptionAdditionalData ifAbsent: []);
		  additionalExceptions: (aDictionary at: #additionalExceptions ifAbsent: []);
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> leJsonV4AddMappingsTo: aJsonMapping [

	super leJsonV4AddMappingsTo: aJsonMapping.
	aJsonMapping
		mapProperty: #exceptionClass
		getter: [ :object | 
			object exceptionClassName ifNotNil: [ object exceptionClass ] ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #exceptionMessageText
		getter: [ :object | object exceptionMessageText ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #exceptionTrace
		getter: [ :object | object exceptionTrace ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #exceptionAdditionalData
		getter: [ :object | object exceptionAdditionalData ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ];
		mapProperty: #additionalExceptions
		getter: [ :object | object additionalExceptions ]
		setter: [ :object :value | 
			self error: 'Cannot set it, use leFromJsonV4Dictionary' ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> testCase: aTestCase startTimestamp: aDateAndTime exception: anException [

	^ (self testCase: aTestCase startTimestamp: aDateAndTime)
		  initializeExceptionClass: anException class
		  messageText: (anException messageText ifEmpty: [ anException class name ])
		  trace: anException stackString
		  additionalData: anException pharoLinkAdditionalData;
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> additionalExceptions [
	"Answer any additional exceptions that were raised while running the test.
	nil = no information collected.
	empty = no additional exceptions."
	<return: #Array or: nil>

	^ additionalExceptions
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> additionalExceptions: anObject [
	additionalExceptions := anObject
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionAdditionalData [
	^ primaryException ifNotNil: [ primaryException exceptionAdditionalData ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionClass [

	^ primaryException exceptionClass
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionClassName [

	^ primaryException ifNotNil: [ primaryException exceptionClassName ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionMessageText [

	^ primaryException ifNotNil: [ primaryException exceptionMessageText ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionTrace [

	^ primaryException ifNotNil: [ primaryException exceptionTrace ]
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> exceptionTrace: aString [

	primaryException exceptionTrace: aString
]

{ #category : #ui }
PharoLinkTestCaseExceptionAnnouncement >> gtTraceFor: aView [
	<gtView>

	primaryException ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Trace';
		priority: 15;
		object: [ primaryException ];
		view: #gtTraceFor:
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> hasAdditionalExceptions [

	^ additionalExceptions isNotNil and: [ additionalExceptions isNotEmpty ]
]

{ #category : #initialization }
PharoLinkTestCaseExceptionAnnouncement >> initializeExceptionClass: aClass messageText: aString trace: anotherString [

 	primaryException := PharoLinkException new
 		exceptionClassName: aClass name;
 		exceptionMessageText: aString;
 		exceptionTrace: anotherString.
]

{ #category : #initialization }
PharoLinkTestCaseExceptionAnnouncement >> initializeExceptionClass: aClass messageText: aString trace: anotherString additionalData:  additionalData [
 
 	primaryException := PharoLinkException new
 		exceptionClassName: (aClass ifNotNil: #name);
 		exceptionMessageText: aString;
 		exceptionTrace: anotherString;
 		exceptionAdditionalData: additionalData.
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
		nextPutAll: (primaryException
			ifNil: [ '<unknown>' ]
			ifNotNil: [ primaryException exceptionClassName ]);
		nextPut: Character space;
		nextPutAll: (primaryException
			ifNil: [ '<none>' ]
			ifNotNil: [ primaryException exceptionMessageText ])
]

{ #category : #ui }
PharoLinkTestCaseExceptionAnnouncement >> summaryAttributes [
	"Answer a collection of key/value attributes that can simply be listed as a summary of the receiver"

	^ super summaryAttributes
		add: 'Exception Class:' -> (primaryException ifNil: [ '<unknown>' ] ifNotNil: [ primaryException exceptionClass ]);
		add: 'Message:' -> (primaryException ifNil: [ '<unknown>' ] ifNotNil: [ primaryException exceptionMessageText ]);
		add: 'Additional Exceptions:' -> 
			(additionalExceptions ifNil: [ 0 ] ifNotNil: [ additionalExceptions size ]);
		yourself.
]
