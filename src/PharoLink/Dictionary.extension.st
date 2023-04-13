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
Dictionary >> languageLinkSerializable [

	self assert: (self keys allSatisfy: #canBePharoLinkPrimitive).
	^ self collect: [ :each | each languageLinkSerializable ].
]

{ #category : #'*PharoLink' }
Dictionary >> pharoLinkUnencodeWith: registry [

	self size = 2 ifTrue: 
		[ self 
			at: '__registryid__'
			ifPresent: [ :id | ^ registry resolve: id ] ].
	^ self collect: [ :each | each pharoLinkUnencodeWith: registry ]
]
