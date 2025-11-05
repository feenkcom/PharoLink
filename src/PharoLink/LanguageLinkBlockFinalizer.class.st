Class {
	#name : #LanguageLinkBlockFinalizer,
	#superclass : #LanguageLinkAbstractFinalizer,
	#instVars : [
		'block'
	],
	#category : 'PharoLink-Platform'
}

{ #category : #accessing }
LanguageLinkBlockFinalizer class >> block: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #accessing }
LanguageLinkBlockFinalizer >> block [
	^ block
]

{ #category : #accessing }
LanguageLinkBlockFinalizer >> block: anObject [
	block := anObject
]

{ #category : #finalization }
LanguageLinkBlockFinalizer >> finalize [
	^ block value
]
