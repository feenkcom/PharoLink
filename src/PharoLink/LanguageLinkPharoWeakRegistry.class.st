Class {
	#name : #LanguageLinkPharoWeakRegistry,
	#superclass : #LanguageLinkAbstractWeakRegistry,
	#instVars : [
		'weakRegistry'
	],
	#category : #'PharoLink-Pharo-Platform'
}

{ #category : #registration }
LanguageLinkPharoWeakRegistry >> destroy [

	weakRegistry := FinalizationRegistry new 
]

{ #category : #initialization }
LanguageLinkPharoWeakRegistry >> initialize [
	super initialize.
	weakRegistry := FinalizationRegistry new.
]

{ #category : #registration }
LanguageLinkPharoWeakRegistry >> registerObject: anObject finalizer: finalizer [

	weakRegistry add: anObject finalizer: finalizer 
]
