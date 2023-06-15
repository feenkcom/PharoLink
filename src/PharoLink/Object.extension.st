Extension { #name : #Object }

{ #category : #'*PharoLink' }
Object >> asGtBareProxyObject [
	^ self
]

{ #category : #'*PharoLink' }
Object >> asGtBareProxyObjectInSession: aGtGemStoneSession [
	^ self
]

{ #category : #'*PharoLink' }
Object >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"
	| answerFlag |

	answerFlag := PharoLinkAnswerByValue flag.
	(answerFlag = #serialized and: [ LeJsonV4 uniqueInstance canSerialize: self ]) ifTrue: 
		[ ^ aPharoLinkRegistry jsonSerializationFor: self ].

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
Object >> gtPharoProxyInitializeWithSession: aProxyContext [
	"Provide a callback from initializing proxy objects."
	^ self
]

{ #category : #'*PharoLink' }
Object >> isBoolean [
	"Answer a boolean indicating whether the receiver is a boolean"

	^ false
]

{ #category : #'*PharoLink' }
Object >> isLanguageLinkProxyObject [
	"Answer a boolean indicating whether the receiver is a LanuageLink proxy object."
	
	^ false
]

{ #category : #'*PharoLink' }
Object >> isPharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver is a PharoLink primitive object"

	^ false
]

{ #category : #'*PharoLink' }
Object >> languageLinkSerializable [

	self error: 'Unable to serialize: ', self printString.
]

{ #category : #'*PharoLink' }
Object >> pharoLinkUnencodeWith: registry [

	^ self
]
