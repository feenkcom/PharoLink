Class {
	#name : 'LanguageLinkSyncMessage',
	#superclass : 'LanguageLinkMessage',
	#instVars : [
		'syncId'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : 'accessing' }
LanguageLinkSyncMessage class >> answerClass [
	^ LanguageLinkAnswer
]

{ #category : 'accessing' }
LanguageLinkSyncMessage class >> type [
	^ #SYNC
]

{ #category : 'accessing' }
LanguageLinkSyncMessage >> answerClass [
	^ self class answerClass
]

{ #category : 'accessing' }
LanguageLinkSyncMessage >> createAnswer [
	^ self answerClass answerFor: self
]

{ #category : 'initialization' }
LanguageLinkSyncMessage >> initializeWith: aLLApplication [

	syncId := aLLApplication settings platform newRandomName
]

{ #category : 'testing' }
LanguageLinkSyncMessage >> isSync [
	^ true
]

{ #category : 'writing' }
LanguageLinkSyncMessage >> privateEncode: aDict [
	super privateEncode: aDict.
	aDict at: #__sync put: self syncId
]

{ #category : 'writing' }
LanguageLinkSyncMessage >> syncId [
	^ syncId
]
