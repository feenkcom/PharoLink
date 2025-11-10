Extension { #name : #SourceFileArray }

{ #category : #'*PharoLink' }
SourceFileArray >> flushChangesFile [

	flushChanges ifFalse: [ ^ self ].
	self changesFileStream ifNotNil: [:stream | stream flush].
	"On Unix (linux and Mac), the readOnly files may be out of sync as they are opened separately (different fd),
	in particular #atEnd may return the wrong result.
	Retrieving the size of each file has the side effect of updationg the state.
	There is still a possible race condition as use of the readOnly files may be in separate processes,
	however we'll assume that they won't want to read the latest changes until after the writer has completed."
	readOnlyQueue itemArray do: [ :each | each second size ].
]
