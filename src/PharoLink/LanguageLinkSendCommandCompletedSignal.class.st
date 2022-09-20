Class {
	#name : #LanguageLinkSendCommandCompletedSignal,
	#superclass : #LanguageLinkSendCommandSignal,
	#category : #'PharoLink-Logging'
}

{ #category : #testing }
LanguageLinkSendCommandCompletedSignal >> isEndSignalType [
	^ true
]

{ #category : #testing }
LanguageLinkSendCommandCompletedSignal >> isStartSignalType [
	^ false
]
