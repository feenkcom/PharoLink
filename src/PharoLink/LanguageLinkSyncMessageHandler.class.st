Class {
	#name : 'LanguageLinkSyncMessageHandler',
	#superclass : 'LanguageLinkMessageHandler',
	#instVars : [
		'answer'
	],
	#category : 'PharoLink-Platform'
}

{ #category : 'accessing' }
LanguageLinkSyncMessageHandler >> answer [
	^ answer
]

{ #category : 'accessing' }
LanguageLinkSyncMessageHandler >> handleMessage [
	answer := callback value: message.
	self assert: answer class = message answerClass.
]

{ #category : 'asserting' }
LanguageLinkSyncMessageHandler >> shouldAnswer [
	^ true
]
