Class {
	#name : #LanguageLinkCallbackMessage,
	#superclass : #LanguageLinkRSyncMessage,
	#instVars : [
		'commandId',
		'observerId',
		'value'
	],
	#category : #'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkCallbackMessage class >> answerClass [
	^ LanguageLinkCallbackAnswer
]

{ #category : #accessing }
LanguageLinkCallbackMessage class >> type [
	^ #CALLBACK
]

{ #category : #accessing }
LanguageLinkCallbackMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
LanguageLinkCallbackMessage >> observerId [
	^ observerId
]

{ #category : #'as yet unclassified' }
LanguageLinkCallbackMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	observerId := dict at: #observerId.
	value := dict at: #value
]

{ #category : #accessing }
LanguageLinkCallbackMessage >> value [
	^ value
]
