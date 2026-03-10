Class {
	#name : #LanguageLinkErrorMessage,
	#superclass : #LanguageLinkRSyncMessage,
	#instVars : [
		'commandId',
		'errorMessage',
		'trace',
		'exceptionData'
	],
	#category : #'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkErrorMessage class >> answerClass [
	^ LanguageLinkErrorAnswer
]

{ #category : #accessing }
LanguageLinkErrorMessage class >> type [
	^ #ERR
]

{ #category : #accessing }
LanguageLinkErrorMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
LanguageLinkErrorMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #accessing }
LanguageLinkErrorMessage >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
LanguageLinkErrorMessage >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #accessing }
LanguageLinkErrorMessage >> exceptionData [
	^ exceptionData
]

{ #category : #accessing }
LanguageLinkErrorMessage >> exceptionData: anObject [
	exceptionData := anObject
]

{ #category : #'as yet unclassified' }
LanguageLinkErrorMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	errorMessage := dict at: #errMsg.
	trace := dict at: #trace.
	exceptionData := dict at: #exceptionData ifAbsent: [].
]

{ #category : #accessing }
LanguageLinkErrorMessage >> trace [
	^ trace
]

{ #category : #accessing }
LanguageLinkErrorMessage >> trace: anObject [
	trace := anObject
]
