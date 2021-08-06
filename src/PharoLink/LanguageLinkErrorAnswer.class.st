Class {
	#name : 'LanguageLinkErrorAnswer',
	#superclass : 'LanguageLinkRAnswer',
	#instVars : [
		'handlingAction'
	],
	#category : 'PharoLink-Platform-Messages'
}

{ #category : 'accessing' }
LanguageLinkErrorAnswer >> handlingAction [
	^ handlingAction
]

{ #category : 'accessing' }
LanguageLinkErrorAnswer >> handlingAction: anObject [
	handlingAction := anObject
]

{ #category : 'encoding' }
LanguageLinkErrorAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #action put: handlingAction encodeAsDictionary
]
