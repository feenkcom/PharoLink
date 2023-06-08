Class {
	#name : #LanguageLinkSerializer,
	#superclass : #LanguageLinkMapper,
	#category : #'PharoLink-Serialization'
}

{ #category : #api }
LanguageLinkSerializer >> serialize: anObject [

	^ serializerWrapper serialize: anObject languageLinkSerializable.
]
