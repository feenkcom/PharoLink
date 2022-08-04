Class {
	#name : #LanguageLinkSocketErrorSignal,
	#superclass : #LanguageLinkSignal,
	#instVars : [
		'message'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkSocketErrorSignal >> message [

	^ message
]

{ #category : #accessing }
LanguageLinkSocketErrorSignal >> message: anObject [

	message := anObject
]

{ #category : #accessing }
LanguageLinkSocketErrorSignal >> printOneLineContentsOn: stream [

	stream print: message.
]
