Class {
	#name : #LanguageLinkPharoWeakRegistry,
	#superclass : #LanguageLinkAbstractWeakRegistry,
	#instVars : [
		'weakRegistry'
	],
	#category : 'PharoLink-Pharo-Platform'
}

{ #category : #registration }
LanguageLinkPharoWeakRegistry >> destroy [
	weakRegistry removeAll
]

{ #category : #initialization }
LanguageLinkPharoWeakRegistry >> initialize [
	super initialize.
	weakRegistry := WeakRegistry new.
]

{ #category : #registration }
LanguageLinkPharoWeakRegistry >> registerObject: anObject finalizer: finalizer [
	weakRegistry 
		add: anObject
		executor: finalizer
]
