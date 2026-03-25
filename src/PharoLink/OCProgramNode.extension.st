Extension { #name : #OCProgramNode }

{ #category : #'*PharoLink' }
OCProgramNode >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
OCProgramNode >> pharoLinkFormattedCode [
	"Answer the string representation of the receiver for sending to the remote server"

	^ self formattedCode
]
