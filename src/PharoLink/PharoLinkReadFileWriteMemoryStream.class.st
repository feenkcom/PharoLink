Class {
	#name : #PharoLinkReadFileWriteMemoryStream,
	#superclass : #Object,
	#instVars : [
		'readWrite',
		'readOnly',
		'readOnlyLimit'
	],
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream class >> readOnly: aStream readOnlyLimit: anInteger readWrite: anotherStream [

	^ self new
		  initializeReadOnly: aStream
		  readOnlyLimit: anInteger
		  readWrite: anotherStream;
		  yourself
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> atEnd [

	^ readOnly position = readOnlyLimit and: [ readWrite atEnd ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> close [

	readOnly close.
	readWrite close
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> closed [

	^ readOnly closed and: [ readWrite closed ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> discardBuffer [

	readOnly discardBuffer.
	readWrite discardBuffer
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> flush [

	readWrite flush
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> initializeReadOnly: aStream readOnlyLimit: anInteger readWrite: anotherStream [

	readOnly := aStream.
	readOnlyLimit := anInteger.
	readWrite := anotherStream
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> isBinary [

	^ readOnly isBinary and: [ readWrite isBinary ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> next [

	self position < readOnlyLimit ifTrue: [ ^ readOnly next ].
	^ readWrite next
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> next: anInteger putAll: aCollection startingAt: startIndex [

	| offset |
	offset := readOnlyLimit - readOnly position max: 0.
	offset > 0 ifTrue: [ 
		| read written |
		read := readOnly next: offset.
		written := aCollection
			           copyFrom: startIndex
			           to: startIndex + offset - 1.
		read = written ifFalse: [ self error: 'readOnly is immutable' ] ].
	^ readWrite
		  next: anInteger - offset
		  putAll: aCollection
		  startingAt: startIndex + offset
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> position [

	readOnly position < readOnlyLimit ifTrue: [ ^ readOnly position ].
	^ readOnlyLimit + readWrite position
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> position: anInteger [

	anInteger < readOnlyLimit
		ifTrue: [ 
			readOnly position: anInteger.
			readWrite position: 0 ]
		ifFalse: [ 
			readOnly position: readOnlyLimit.
			readWrite position: anInteger - readOnlyLimit ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> readInto: aCollection startingAt: startIndex count: n [

	| max read |
	max := self size - self position min: n.
	read := 0.
	readOnly position < readOnlyLimit ifTrue: [ 
		read := readOnly
			        readInto: aCollection
			        startingAt: startIndex
			        count: max ].
	read < max ifTrue: [ 
		read := read + (readWrite
			         readInto: aCollection
			         startingAt: startIndex + read
			         count: max - read) ].
	^ read
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> size [

	^ readOnlyLimit + readWrite size
]
