Class {
	#name : #LanguageLinkStartStopSignal,
	#superclass : #LanguageLinkSignal,
	#instVars : [
		'subject'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkStartStopSignal >> subject [
	^ subject
]

{ #category : #accessing }
LanguageLinkStartStopSignal >> subject: anObject [
	subject := anObject
]
