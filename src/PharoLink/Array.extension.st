Extension { #name : #Array }

{ #category : #'*PharoLink' }
Array >> asGtBareProxyObject [

	^ self collect: [ :each | each asGtBareProxyObject ]
]

{ #category : #'*PharoLink' }
Array >> asGtProxyObject [
	"Answer an Array of the receiver's entries converted to proxy objects.
	Don't rely on Symbol>>value: as it uses #perform: which the bare proxy doesn't understand."

	^ self collect: [ :each | each asGtProxyObject ]
]

{ #category : #'*PharoLink' }
Array >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"
	| answerFlag canBePrimitive |

	answerFlag := PharoLinkAnswerByValue flag.
	answerFlag = #never ifTrue: [ ^ aPharoLinkRegistry jsonObjectFor: self ].
	canBePrimitive := self canBePharoLinkPrimitive.
	(answerFlag = #valueOnly and: [ canBePrimitive not ]) ifTrue:
		[ self error: 'Proxies not allowed' ].
	canBePrimitive ifTrue: [ ^ self ].
	^ self collect: [ :each | each asPharoLinkObjectRegistry: aPharoLinkRegistry ]
]

{ #category : #'*PharoLink' }
Array >> canBePharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver can be a PharoLink primitive object,
	i.e. it can be completely encoded in JSON format."

	^ self allSatisfy: #canBePharoLinkPrimitive
]

{ #category : #'*PharoLink' }
Array >> gtPharoProxyInitializeWithSession: aSession [
	"Update the session from the given session".
	
	self do: [ :each |
		each gtPharoProxyInitializeWithSession: aSession ]
]

{ #category : #'*PharoLink' }
Array >> languageLinkSerializable [

	^ self collect: [ :each | each languageLinkSerializable ]
]

{ #category : #'*PharoLink' }
Array >> pharoLinkUnencodeWith: registry [

	^ self collect: [ :each | each pharoLinkUnencodeWith: registry ]
]
