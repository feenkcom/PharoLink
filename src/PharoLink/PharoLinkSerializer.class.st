Class {
	#name : #PharoLinkSerializer,
	#superclass : #Object,
	#category : #'PharoLink-Serializer'
}

{ #category : #private }
PharoLinkSerializer >> deserialize: aString [

	^ NeoJSONReader fromString: aString
]

{ #category : #private }
PharoLinkSerializer >> serialize: anObject [

	^ PharoLinkJSONWriter toString: anObject
]
