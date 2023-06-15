Class {
	#name : #LanguageLinkRSyncMessage,
	#superclass : #LanguageLinkRMessage,
	#instVars : [
		'syncId'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkRSyncMessage class >> answerClass [
	^ LanguageLinkRAnswer
]

{ #category : #accessing }
LanguageLinkRSyncMessage class >> type [
	^ #RSYNC
]

{ #category : #accessing }
LanguageLinkRSyncMessage >> answerClass [
	^ self class answerClass
]

{ #category : #accessing }
LanguageLinkRSyncMessage >> createAnswer [
	^ self answerClass answerFor: self
]

{ #category : #testing }
LanguageLinkRSyncMessage >> isSync [
	^ true
]

{ #category : #'as yet unclassified' }
LanguageLinkRSyncMessage >> privateDecode: dict [
	super privateDecode: dict.
	syncId := dict at: #__sync
]

{ #category : #accessing }
LanguageLinkRSyncMessage >> syncId [
	^ syncId
]
