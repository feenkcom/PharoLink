Class {
	#name : 'LanguageLinkCallbackAnswer',
	#superclass : 'LanguageLinkRAnswer',
	#instVars : [
		'value'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : 'encoding' }
LanguageLinkCallbackAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #value put: value
]

{ #category : 'accessing' }
LanguageLinkCallbackAnswer >> value [
	^ value
]

{ #category : 'accessing' }
LanguageLinkCallbackAnswer >> value: anObject [
	value := anObject
]
