Class {
	#name : #LanguageLinkStubMessage,
	#superclass : #LanguageLinkSyncMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkStubMessage class >> answerClass [
	^ LanguageLinkStubAnswer
]

{ #category : #accessing }
LanguageLinkStubMessage class >> type [
	^ #STUB
]

{ #category : #accessing }
LanguageLinkStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
LanguageLinkStubMessage >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
LanguageLinkStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #accessing }
LanguageLinkStubMessage >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encode }
LanguageLinkStubMessage >> privateEncode: aDict [
	super privateEncode: aDict.
	aDict at: #ivar1 put: ivar1.
	aDict at: #ivar2f put: ivar2 first.
	aDict at: #ivar2r put: ivar2 allButFirst.
]
