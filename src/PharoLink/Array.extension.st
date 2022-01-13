Extension { #name : #Array }

{ #category : #'*PharoLink' }
Array >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"

	^ self collect: [ :each | each asPharoLinkObjectRegistry: aPharoLinkRegistry ]
]
