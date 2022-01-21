Extension { #name : #Float }

{ #category : #'*PharoLink' }
Float >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
Float >> isPharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"

	^ true
]
