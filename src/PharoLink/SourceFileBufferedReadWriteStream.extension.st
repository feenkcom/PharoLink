Extension { #name : #SourceFileBufferedReadWriteStream }

{ #category : #'*PharoLink' }
SourceFileBufferedReadWriteStream >> discardBuffer [

	bufferOffset := -1.
	bufferLength := 0.
	isDirty := false.
]
