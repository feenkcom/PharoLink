Class {
	#name : #LanguageLinkRStubMessage,
	#superclass : #LanguageLinkRSyncMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkRStubMessage class >> answerClass [
	^ LanguageLinkRStubAnswer
]

{ #category : #accessing }
LanguageLinkRStubMessage class >> type [
	^ #RSTUB
]

{ #category : #accessing }
LanguageLinkRStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
LanguageLinkRStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #'as yet unclassified' }
LanguageLinkRStubMessage >> privateDecode: dict [
	super privateDecode: dict.
	ivar1 := dict at: #ivar1.
	ivar2 := {dict at: #ivar2f} , (dict at: #ivar2r)
]
