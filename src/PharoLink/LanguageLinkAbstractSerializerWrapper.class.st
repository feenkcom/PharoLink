Class {
	#name : #LanguageLinkAbstractSerializerWrapper,
	#superclass : #Object,
	#category : #'PharoLink-Platform'
}

{ #category : #private }
LanguageLinkAbstractSerializerWrapper >> deserialize: aString [
	self subclassResponsibility
]

{ #category : #private }
LanguageLinkAbstractSerializerWrapper >> serialize: anObject [
	self subclassResponsibility
]
