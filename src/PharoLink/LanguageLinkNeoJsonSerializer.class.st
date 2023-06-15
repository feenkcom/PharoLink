Class {
	#name : #LanguageLinkNeoJsonSerializer,
	#superclass : #LanguageLinkAbstractSerializerWrapper,
	#category : 'PharoLink-Pharo-MessageBroker'
}

{ #category : #private }
LanguageLinkNeoJsonSerializer >> deserialize: aString [
	^ NeoJSONReader fromString: aString
]

{ #category : #private }
LanguageLinkNeoJsonSerializer >> serialize: anObject [
	^ NeoJSONWriter toString: anObject
]
