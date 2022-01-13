Extension { #name : #Object }

{ #category : #'*PharoLink' }
Object >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"

	^ aPharoLinkRegistry jsonObjectFor: self
]

{ #category : #'*PharoLink' }
Object >> isBoolean [
	"Answer a boolean indicating whether the receiver is a boolean"

	^ false
]
