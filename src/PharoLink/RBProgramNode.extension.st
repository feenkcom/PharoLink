Extension { #name : #RBProgramNode }

{ #category : #'*PharoLink' }
RBProgramNode >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink' }
RBProgramNode >> pharoLinkFormattedCode [
	"Answer the string representation of the receiver for sending to the remote server"

	^ self formattedCode
]
