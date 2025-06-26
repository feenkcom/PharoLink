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
		forPharo11AndPharo12: [ weakRegistry := FinalizationRegistry new ]
		forPharo10: [ weakRegistry removeAll ].
]

{ #category : #initialization }
LanguageLinkPharoWeakRegistry >> initialize [
	super initialize.
	weakRegistry := FinalizationRegistry new.
]

{ #category : #registration }
LanguageLinkPharoWeakRegistry >> registerObject: anObject finalizer: finalizer [

	self
		forPharo11AndPharo12: [ weakRegistry add: anObject finalizer: finalizer ]
		forPharo10: [ weakRegistry add: anObject executor: finalizer ]
]
