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

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> isAbstract [

	^ self == PharoLinkTestCaseExceptionAnnouncement
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> leFromJsonV4Dictionary: aDictionary [

	^ (super leFromJsonV4Dictionary: aDictionary)
		  initializeExceptionClass: (aDictionary at: #exceptionClass) asClass
		  messageText: (aDictionary at: #exceptionMessageText)
		  trace: (aDictionary at: #exceptionTrace);
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> leJsonV4AddMappingsTo: aJsonMapping [

	super leJsonV4AddMappingsTo: aJsonMapping.
	aJsonMapping
		mapProperty: #exceptionClass
		getter: [ :object | object exceptionClass name ]
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

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> initializeExceptionClass: aClass messageText: aString trace: anotherString [

	exceptionClass := aClass.
	exceptionMessageText := aString.
	exceptionTrace := anotherString
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> printOn: aStream [

	super printOn: aStream.

	aStream
		nextPut: Character space;
		nextPutAll: exceptionClass name;
		nextPut: Character space;
		nextPutAll: exceptionMessageText
]
