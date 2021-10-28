Class {
	#name : #PharoLinkTestCaseExceptionAnnouncement,
	#superclass : #PharoLinkTestCaseEndAnnouncement,
	#instVars : [
		'exceptionClass',
		'exceptionMessageText'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement class >> testCase: aTestCase exception: anException [

	^ (self testCase: aTestCase)
		  initializeExceptionClass: anException class
		  messageText: anException messageText;
		  yourself
]

{ #category : #accessing }
PharoLinkTestCaseExceptionAnnouncement >> initializeExceptionClass: aClass messageText: aString [

	exceptionClass := aClass.
	exceptionMessageText := aString
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
