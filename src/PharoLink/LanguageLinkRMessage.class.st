Class {
	#name : #LanguageLinkRMessage,
	#superclass : #LanguageLinkAbstractMessage,
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #actions }
LanguageLinkRMessage class >> decodeFrom: aDict [
	^ self new
		privateDecode: aDict;
		yourself
]

{ #category : #testing }
LanguageLinkRMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ true
]

{ #category : #accessing }
LanguageLinkRMessage class >> type [
	^ #RMSG
]

{ #category : #'as yet unclassified' }
LanguageLinkRMessage >> privateDecode: aDict [
]
