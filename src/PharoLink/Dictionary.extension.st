Extension { #name : #Dictionary }

{ #category : #'*PharoLink' }
Dictionary >> asPharoLinkObjectRegistry: aPharoLinkRegistry [
	"Answer the receiver with non-primitive objects represented as proxies"
	| proxyDict |

	(self at: #'__pharolinkImmediate' ifAbsent: [ false ]) ifTrue: [ ^ self ].

	(self keys allSatisfy: [ :key | aPharoLinkRegistry isPrimitive: key ]) ifFalse:
		[ self error: 'Dictionary keys must be primitive types (immediate)' ].
	proxyDict := self class new: self size.
	self keysAndValuesDo: [ :key :value |
		proxyDict
			at: key 
			put: (value asPharoLinkObjectRegistry: aPharoLinkRegistry) ].
	^ proxyDict
]

{ #category : #'*PharoLink' }
Dictionary >> isLanguageLinkValue [
	^ true
]
