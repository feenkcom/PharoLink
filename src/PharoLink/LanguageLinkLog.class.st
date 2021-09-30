Class {
	#name : #LanguageLinkLog,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : 'PharoLink-Logs'
}

{ #category : #accessing }
LanguageLinkLog class >> message: aString [
	^ self new
		message: aString;
		yourself
]

{ #category : #testing }
LanguageLinkLog >> isError [
	^ false
]

{ #category : #accessing }
LanguageLinkLog >> message [
	^ message
]

{ #category : #accessing }
LanguageLinkLog >> message: anObject [
	message := anObject
]

{ #category : #printing }
LanguageLinkLog >> printOn: str [
	message
		ifNil: [ super printOn: str ]
		ifNotNil: [
			str 
				<< self class name; 
				<< ': ';
				<< message;
				cr ]
]
