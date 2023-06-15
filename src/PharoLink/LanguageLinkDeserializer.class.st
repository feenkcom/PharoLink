Class {
	#name : #LanguageLinkDeserializer,
	#superclass : #LanguageLinkMapper,
	#category : #'PharoLink-Serialization'
}

{ #category : #'private protocol' }
LanguageLinkDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> application [
	^ self executionHandler application
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> buildProxyFor: rawObject [

	^ self subclassResponsibility 
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> deserialize: str [
	^ self privateDeserialize: (serializerWrapper deserialize: str).
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> objectRegistry [
	^ self executionHandler objectRegistry
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> privateDeserialize: rawObj [
	rawObj isCollection ifFalse: [ ^ rawObj ].
	rawObj isDictionary and: [ (rawObj includesKey: #__class__) 
		ifTrue: [ ^ self reifyProxyFor: rawObj ] ].
	^ rawObj collect: [ :elem | self privateDeserialize: elem ]
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> reifyProxyFor: rawObj [
	^ self objectRegistry resolveEncodedObject: rawObj ifAbsent: [ self buildProxyFor: rawObj ]
]
