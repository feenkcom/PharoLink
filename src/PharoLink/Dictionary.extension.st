Extension { #name : #Dictionary }

{ #category : #'*PharoLink' }
Dictionary >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"
	| proxyDict answerFlag canBePrimitive |

	answerFlag := PharoLinkAnswerByValue flag.
	answerFlag = #never ifTrue: [ ^ aPharoLinkRegistry jsonObjectFor: self ].
	canBePrimitive := self canBePharoLinkPrimitive.
	(answerFlag = #valueOnly and: [ canBePrimitive not ]) ifTrue:
		[ self error: 'Proxies not allowed' ].
	canBePrimitive ifTrue: [ ^ self ].

	proxyDict := self class new: self size.
	self keysAndValuesDo: [ :key :value |
		proxyDict
			at: key 
			put: (value asPharoLinkObjectRegistry: aPharoLinkRegistry) ].
	^ proxyDict
]

{ #category : #'*PharoLink' }
Dictionary >> canBePharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver can be a PharoLink primitive object,
	i.e. it can be completely encoded in JSON format."

	^ (self allSatisfy: #canBePharoLinkPrimitive) and:
		[ self keys allSatisfy: #canBePharoLinkPrimitive ].

]

{ #category : #'*PharoLink' }
Dictionary >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
Dictionary >> isPharoLinkPrimitiveSuperseeded [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"
	| answerFlag canBePrimitive |
	
	answerFlag := PharoLinkAnswerByValue flag.

	"If PharoLinkAnswerByValue is never, always be answered as a proxy"
	answerFlag = #never ifTrue: [ ^ false ].

	canBePrimitive := (self allSatisfy: #isPharoLinkPrimitive) and:
		[ self keys allSatisfy: #isPharoLinkPrimitive ].

	"If PharoLinkAnswerByValue is if possible, use the calculated value."	
	answerFlag = #valueIfPossible ifTrue: [ ^ canBePrimitive ].

	"If PharoLinkAnswerByValue is by value only, raise an error if it can't be serialised"
	canBePrimitive ifFalse: [ self error: 'Must be a primitive' ].
	^ true.
]
