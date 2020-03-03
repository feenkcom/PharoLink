Class {
	#name : #PharoLinkErrorHandling,
	#superclass : #PharoLinkApplicationTest,
	#category : #'PharoLink-Tests'
}

{ #category : #tests }
PharoLinkErrorHandling >> testMNUError [

	self
		should: [ application newCommandFactory sendAndWait: 'llCommand doesntKnowThis' ]
		raise: PharoLinkLinkRemoteError
		withExceptionDo: [ :ex | 
			self assert: ex errorMessage equals: 'MessageNotUnderstood: PharoLinkEvalCommand>> #doesntKnowThis' ]
]
