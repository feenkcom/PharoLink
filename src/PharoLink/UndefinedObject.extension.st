Extension { #name : #UndefinedObject }

{ #category : #'*PharoLink' }
UndefinedObject >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
UndefinedObject >> pharoLinkFormattedCode [
	"Answer the string representation of the receiver for sending to the remote server"

	^ #nil
]
