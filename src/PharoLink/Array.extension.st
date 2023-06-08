Extension { #name : #Array }

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
Array >> languageLinkSerializable [

	^ self collect: [ :each | each languageLinkSerializable ]
]

{ #category : #'*PharoLink' }
Array >> pharoLinkUnencodeWith: registry [

	^ self collect: [ :each | each pharoLinkUnencodeWith: registry ]
]
