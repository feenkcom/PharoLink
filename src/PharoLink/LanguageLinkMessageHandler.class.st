Class {
	#name : 'LanguageLinkMessageHandler',
	#superclass : 'Object',
	#instVars : [
		'message',
		'callback'
	],
	#category : 'PharoLink-Platform'
}

{ #category : 'as yet unclassified' }
LanguageLinkMessageHandler class >> forMessage: msg callback: block [
	^ (self handlerClassForMessage: msg) new
		message: msg;
		callback: block;
		yourself
]

{ #category : 'as yet unclassified' }
LanguageLinkMessageHandler class >> handlerClassForMessage: msg [
	^ msg isSync
		ifTrue: [ LanguageLinkSyncMessageHandler ]
		ifFalse: [ LanguageLinkAsyncMessageHandler ]
]

{ #category : 'accessing' }
LanguageLinkMessageHandler >> callback [
	^ callback
]

{ #category : 'accessing' }
LanguageLinkMessageHandler >> callback: anObject [
	callback := anObject
]

{ #category : 'accessing' }
LanguageLinkMessageHandler >> handleMessage [
	callback value: message
]

{ #category : 'accessing' }
LanguageLinkMessageHandler >> message [
	^ message
]

{ #category : 'accessing' }
LanguageLinkMessageHandler >> message: anObject [
	message := anObject
]

{ #category : 'asserting' }
LanguageLinkMessageHandler >> shouldAnswer [
	^ false
]
