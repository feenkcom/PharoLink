Class {
	#name : #LanguageLinkRAnswer,
	#superclass : #LanguageLinkAbstractAnswer,
	#category : #'PharoLink-Platform-Messages'
}

{ #category : #encoding }
LanguageLinkRAnswer >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type. 
	self privateEncode: dict.
	^ dict
]

{ #category : #encoding }
LanguageLinkRAnswer >> privateEncode: dict [
	dict at: #__sync put: self syncId
]

{ #category : #writing }
LanguageLinkRAnswer >> syncId [
	^ message syncId
]
