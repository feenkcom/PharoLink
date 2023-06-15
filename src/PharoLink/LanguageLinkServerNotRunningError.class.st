Class {
	#name : #LanguageLinkServerNotRunningError,
	#superclass : #LanguageLinkError,
	#instVars : [
		'application'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : #accessing }
LanguageLinkServerNotRunningError >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkServerNotRunningError >> application: anObject [
	application := anObject
]
