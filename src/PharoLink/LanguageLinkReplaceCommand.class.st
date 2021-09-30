Class {
	#name : #LanguageLinkReplaceCommand,
	#superclass : #LanguageLinkErrorHandlingAction,
	#instVars : [
		'newCommand'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : #accessing }
LanguageLinkReplaceCommand >> actionSymbol [
	^ #'REPLACE_COMMAND'
]

{ #category : #encoding }
LanguageLinkReplaceCommand >> encodeAsDictionary [
	| response |
	response := super encodeAsDictionary.
	response at: #command put: newCommand encodeAsDictionary.
	^ response
]

{ #category : #accessing }
LanguageLinkReplaceCommand >> newCommand [
	^ newCommand
]

{ #category : #accessing }
LanguageLinkReplaceCommand >> newCommand: anObject [
	newCommand := anObject
]
