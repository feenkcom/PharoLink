Extension { #name : #Object }

{ #category : #'*PharoLink' }
Object >> gtDeclarativeViewSelectors [
	"Answer a collection of the objects view titles and associated initial priorities"

	^Array streamContents: [ :stream |
		(self gtViewsInContext: nil) do: [ :view | 
			view canBeGtDeclarativeView ifTrue: [
				stream nextPut: view definingMethod selector ] ] ].

]

{ #category : #'*PharoLink' }
Object >> isBoolean [
	"Answer a boolean indicating whether the receiver is a boolean"

	^ false
]
