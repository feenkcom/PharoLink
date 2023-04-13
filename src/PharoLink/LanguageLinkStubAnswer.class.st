Class {
	#name : #LanguageLinkStubAnswer,
	#superclass : #LanguageLinkAnswer,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #converting }
LanguageLinkStubAnswer >> decode: dict [
	ivar1 := dict at: #ivar1.
	ivar2 := { dict at: #ivar2f } , (dict at: #ivar2r)
]

{ #category : #accessing }
LanguageLinkStubAnswer >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
LanguageLinkStubAnswer >> ivar2 [
	^ ivar2
]
