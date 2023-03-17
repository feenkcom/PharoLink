Extension { #name : #OutOfMemory }

{ #category : #'*PharoLink' }
OutOfMemory >> pharoLinkAdditionalData [
	| sizeRequested |
	sizeRequested := self signalerContext 
		ifNil: [ ^ 'context is nil' ]
		ifNotNil: [ self signalerContext stack
			detect: [:aContext | 
				aContext selector = #handleFailingBasicNew:]
			ifFound: [:aContext | 
				aContext tempNamed: #sizeRequested ]
			ifNone: ['context not found'] ].
	
	^ {#sizeRequested -> sizeRequested} asDictionary.
]
