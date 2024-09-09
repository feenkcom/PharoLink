Extension { #name : #OrderedCollection }

{ #category : #'*PharoLink' }
OrderedCollection >> asGtBareProxyObject [

	^ self collect: [ :each | each asGtBareProxyObject ]
]

{ #category : #'*PharoLink' }
OrderedCollection >> asGtProxyObject [
	"Answer a Dictionary of the receiver's entries converted to proxy objects.
	Don't rely on Symbol>>value: as it uses #perform: which the bare proxy doesn't understand."

	^ self collect: [ :each | each asGtProxyObject ]
	
]

{ #category : #'*PharoLink' }
OrderedCollection >> gtPharoProxyInitializeWithSession: aSession [
	"Update the session from the given session".
	
	self do: [ :each |
		each gtPharoProxyInitializeWithSession: aSession ]
]
