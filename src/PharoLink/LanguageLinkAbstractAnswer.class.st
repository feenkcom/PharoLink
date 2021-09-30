Class {
	#name : #LanguageLinkAbstractAnswer,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #'instance creation' }
LanguageLinkAbstractAnswer class >> answerFor: aMessage [
	^ self new
		message: aMessage;
		yourself
]

{ #category : #accessing }
LanguageLinkAbstractAnswer >> message [
	^ message
]

{ #category : #accessing }
LanguageLinkAbstractAnswer >> message: anObject [
	message := anObject
]

{ #category : #accessing }
LanguageLinkAbstractAnswer >> type [
	^ message type
]
