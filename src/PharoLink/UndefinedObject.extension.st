Extension { #name : #UndefinedObject }

{ #category : #'*PharoLink' }
UndefinedObject >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
UndefinedObject >> isPharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"

	^ true
]

{ #category : #'*PharoLink' }
UndefinedObject >> languageLinkSerializable [

	^ self
]

{ #category : #'*PharoLink' }
UndefinedObject >> pharoLinkFormattedCode [
	"Answer the string representation of the receiver for sending to the remote server"

	^ #nil
]
