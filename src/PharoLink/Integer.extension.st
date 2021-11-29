Extension { #name : #Integer }

{ #category : #'*PharoLink' }
Integer >> digitAt: anExponent [

	^ self byteAt: anExponent
]

{ #category : #'*PharoLink' }
Integer >> isLanguageLinkValue [
	^ true
]
