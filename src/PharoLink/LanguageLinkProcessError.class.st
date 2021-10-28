"
A LanguageLinkProcessError is used to signal failure of an external process run with {{gtClass:GtUnixSubprocess}}.
"
Class {
	#name : #LanguageLinkProcessError,
	#superclass : #Error,
	#instVars : [
		'application',
		'process'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : #accessing }
LanguageLinkProcessError >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkProcessError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
LanguageLinkProcessError >> description [ 

	^ String streamContents: [ :stream |
		self printOn: stream ]
]

{ #category : #printing }
LanguageLinkProcessError >> printOn: aStream [

	aStream
		<< 'Exteranl process error'; cr;
		<< '======================'; cr;
		cr.
	messageText ifNotNil: 
		[ aStream << messageText; cr ].
	aStream cr.
	process
		ifNil: [ application serverStatusOn: aStream process: application processHandler ]
		ifNotNil: [ application serverStatusOn: aStream process: process ]

]

{ #category : #accessing }
LanguageLinkProcessError >> process [
	^ process
]

{ #category : #accessing }
LanguageLinkProcessError >> process: anObject [
	process := anObject
]
