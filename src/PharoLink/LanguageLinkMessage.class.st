Class {
	#name : #LanguageLinkMessage,
	#superclass : #LanguageLinkAbstractMessage,
	#category : #'PharoLink-Platform-Messages'
}

{ #category : #testing }
LanguageLinkMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ false
]

{ #category : #accessing }
LanguageLinkMessage class >> type [
	^ #MSG
]

{ #category : #encoding }
LanguageLinkMessage >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type. 
	self privateEncode: dict.
	^ dict
]

{ #category : #testing }
LanguageLinkMessage >> isSync [
	self subclassResponsibility
]

{ #category : #encoding }
LanguageLinkMessage >> privateEncode: dict [
]
