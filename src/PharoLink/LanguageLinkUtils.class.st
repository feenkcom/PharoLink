Class {
	#name : #LanguageLinkUtils,
	#superclass : #Object,
	#category : 'PharoLink-Core'
}

{ #category : #accessing }
LanguageLinkUtils class >> base64Decode: aCharacterStream [

	| fuelStream |
	fuelStream := ReadWriteStream on: (ByteArray new: 100).
	Base64MimeConverter new
		mimeStream: aCharacterStream;
		dataStream: fuelStream;
		mimeDecodeToByteArray.
	^ FLMaterializer materializeFromByteArray: fuelStream contents
]

{ #category : #accessing }
LanguageLinkUtils class >> base64Encode: anObject [

	^ String streamContents: [ :stream | 
		  self base64Encode: anObject to: stream ]
]

{ #category : #accessing }
LanguageLinkUtils class >> base64Encode: anObject to: aCharacterStream [

	| fuelStream |
	fuelStream := ReadWriteStream on: (ByteArray new: 100).
	FLSerializer serialize: anObject on: fuelStream.
	fuelStream reset.
	Base64MimeConverter mimeEncode: fuelStream to: aCharacterStream
]

{ #category : #'instance creation' }
LanguageLinkUtils class >> newVariableName [
	^ 'll' , UUID new asString36
]
