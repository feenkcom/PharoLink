Class {
	#name : #LanguageLinkSerializer,
	#superclass : #LanguageLinkMapper,
	#category : #'PharoLink-Serialization'
}

{ #category : #api }
LanguageLinkSerializer >> serialize: anObject [
	| serializedObject |

	serializedObject := (anObject isKindOf: LanguageLinkProxyObject)
		ifTrue: [ {
				'__class__' -> anObject remoteClass.
				'__registryid__' -> anObject name.
				} asDictionary ]
		ifFalse: [ anObject ].
	^ serializerWrapper serialize: serializedObject
]
