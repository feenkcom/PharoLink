Class {
	#name : #LanguageLinkMsgPackSerializer,
	#superclass : #LanguageLinkAbstractSerializerWrapper,
	#category : #'PharoLink-MessageBroker'
}

{ #category : #private }
LanguageLinkMsgPackSerializer >> deserialize: aByteArray [
	^ MpDecoder decode: aByteArray
]

{ #category : #private }
LanguageLinkMsgPackSerializer >> serialize: anObject [
	^ MpEncoder encode: anObject
]
