Class {
	#name : #LanguageLinkUpdatePromiseMessage,
	#superclass : #LanguageLinkRAsyncMessage,
	#instVars : [
		'promiseId',
		'value'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : #accessing }
LanguageLinkUpdatePromiseMessage class >> type [
	^ #EVAL
]

{ #category : #'as yet unclassified' }
LanguageLinkUpdatePromiseMessage >> privateDecode: dict [
	super privateDecode: dict.
	promiseId := dict at: #id.
	value := dict at: #value
]

{ #category : #accessing }
LanguageLinkUpdatePromiseMessage >> promiseId [
	^ promiseId
]

{ #category : #accessing }
LanguageLinkUpdatePromiseMessage >> value [
	^ value
]
