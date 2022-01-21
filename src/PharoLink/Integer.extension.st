Extension { #name : #Integer }

{ #category : #'*PharoLink' }
Integer >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
Integer >> isPharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"

	^ true
]
