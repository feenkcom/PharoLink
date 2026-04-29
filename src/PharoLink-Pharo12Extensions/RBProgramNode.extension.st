Extension { #name : #RBProgramNode }

{ #category : #'*PharoLink-Pharo12Extensions' }
RBProgramNode >> isLanguageLinkValue [
	^ true
]

{ #category : #'*PharoLink-Pharo12Extensions' }
RBProgramNode >> pharoLinkFormattedCode [
	"Answer the string representation of the receiver for sending to the remote server"

	^ self formattedCode
]
