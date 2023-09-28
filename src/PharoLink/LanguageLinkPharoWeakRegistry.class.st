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

	self
		forPharo11: [ weakRegistry := nil ]
		forPharo10: [ weakRegistry removeAll ].
]

{ #category : #initialization }
LanguageLinkPharoWeakRegistry >> initialize [
	super initialize.
	weakRegistry := self
		forPharo11: [ FinalizationRegistry new ]
		forPharo10: [ WeakRegistry new ].
]

{ #category : #registration }
LanguageLinkPharoWeakRegistry >> registerObject: anObject finalizer: finalizer [
	weakRegistry add: anObject finalizer: finalizer
]
