Class {
	#name : #PharoLinkReadFileWriteMemoryStream,
	#superclass : #Object,
	#instVars : [
		'readWrite',
		'readOnly',
		'readOnlyLimit',
		'position'
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

	^ position >= readOnlyLimit and: [ readWrite atEnd ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> close [

	readOnly close.
	readWrite close.
	position := 0.
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> closed [

	^ readOnly closed and: [ readWrite closed ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> collectionSpecies [
	^ self isBinary
		ifTrue: [ ByteArray ]
		ifFalse: [ String ]
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
	readWrite := anotherStream.
	position := 0.
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> isBinary [

	^ readOnly isBinary and: [ readWrite isBinary ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> next [
	| ch |
	
	ch := position < readOnlyLimit 
		ifTrue: [ readOnly next ]
		ifFalse: [ readWrite next ].
	ch ifNotNil: [ position := position + 1 ].
	^ ch
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> next: aQuantity [

	| read collection |

	collection := self collectionSpecies new: aQuantity.	

	read := self 
		readInto: collection 
		startingAt: 1 
		count: aQuantity.

	^ read = aQuantity 
		ifTrue: [ collection ]
		ifFalse: [ collection copyFrom: 1 to: read - 1 ]    
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> next: anInteger putAll: aCollection startingAt: startIndex [
	"Write anInteger characters/bytes from aCollection starting at startIndex."
	| offset |

	offset := readOnlyLimit - position max: 0.
	offset > 0 ifTrue: [ 
		| read written |
		read := readOnly next: offset.
		written := aCollection
			           copyFrom: startIndex
			           to: startIndex + offset - 1.
		read = written ifFalse: [ self error: 'readOnly is immutable' ] ].
	position := position + anInteger - offset.
	^ readWrite
		  next: anInteger - offset
		  putAll: aCollection
		  startingAt: startIndex + offset
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> nextPutAll: aCollection [

	^ self next: aCollection size putAll: aCollection startingAt: 1.
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> peek [

	position < readOnlyLimit ifTrue: [ ^ readOnly peek ].
	^ readWrite peek
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> position [

	^ position
	"readOnly position < readOnlyLimit ifTrue: [ ^ readOnly position ].
	^ readOnlyLimit + readWrite position"
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> position: anInteger [

	position := anInteger.
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

	max := self size - position min: n.
	read := 0.
	position < readOnlyLimit ifTrue: [ 
		read := readOnly
			        readInto: aCollection
			        startingAt: startIndex
			        count: max ].
	read < max ifTrue: [ 
		read := read + (readWrite
			         readInto: aCollection
			         startingAt: startIndex + read
			         count: max - read) ].
	position := position + read.
	^ read
]

{ #category : #positioning }
PharoLinkReadFileWriteMemoryStream >> setToEnd [

	self position: self size.
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> size [

	^ readOnlyLimit + readWrite size
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStream >> upToEnd [

	^ self next: self size - position.
]
