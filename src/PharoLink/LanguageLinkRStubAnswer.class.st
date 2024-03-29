Class {
	#name : #LanguageLinkRStubAnswer,
	#superclass : #LanguageLinkRAnswer,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkRStubAnswer >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
LanguageLinkRStubAnswer >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encoding }
LanguageLinkRStubAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #ivar1 put: ivar1.
	dict at: #ivar2f put: ivar2 first.
	dict at: #ivar2r put: ivar2 allButFirst.
]
