Class {
	#name : #LanguageLinkErrorHandlingAction,
	#superclass : #Object,
	#category : 'PharoLink-ErrorHandling'
}

{ #category : #accessing }
LanguageLinkErrorHandlingAction >> actionSymbol [
	self subclassResponsibility
]

{ #category : #encoding }
LanguageLinkErrorHandlingAction >> encodeAsDictionary [
	^ { #action -> self actionSymbol } asDictionary
]
