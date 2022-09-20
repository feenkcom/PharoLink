Class {
	#name : #LanguageLinkSendCommandInitiatedSignal,
	#superclass : #LanguageLinkSendCommandSignal,
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkSendCommandInitiatedSignal class >> eventType [
	^ LanguageLinkSendCommandEvent
]

{ #category : #testing }
LanguageLinkSendCommandInitiatedSignal >> isEndSignalType [
	^ false
]

{ #category : #testing }
LanguageLinkSendCommandInitiatedSignal >> isStartSignalType [
	^ true
]
