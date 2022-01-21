Extension { #name : #String }

{ #category : #'*PharoLink' }
String >> isPharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"

	^ true
]

{ #category : #'*PharoLink' }
String >> pharoLinkFormattedCode [
	"Answer the string representation of the receiver for sending to the remote server"

	^ self
]
