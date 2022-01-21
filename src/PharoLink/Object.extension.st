Extension { #name : #Object }

{ #category : #'*PharoLink' }
Object >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"

	^ self isPharoLinkPrimitive 
		ifTrue: [ self ]
		ifFalse: [ aPharoLinkRegistry jsonObjectFor: self ]
]

{ #category : #'*PharoLink' }
Object >> canBePharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver can be a PharoLink primitive object,
	i.e. it can be completely encoded in JSON format.
	The default answer is whether it is a primitive."

	^ self isPharoLinkPrimitive
]

{ #category : #'*PharoLink' }
Object >> isBoolean [
	"Answer a boolean indicating whether the receiver is a boolean"

	^ false
]

{ #category : #'*PharoLink' }
Object >> isPharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"

	^ false
]
