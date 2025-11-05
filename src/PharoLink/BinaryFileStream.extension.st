Extension { #name : #BinaryFileStream }

{ #category : #'*PharoLink' }
BinaryFileStream >> asOpenStream [
	"Answer an open copy of the receiver"

	^ file openForWrite: forWrite
]
