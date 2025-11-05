Class {
	#name : #PharoLinkReadFileWriteStreamExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'readOnlyStream',
		'readWriteStream'
	],
	#category : #'PharoLink-Examples'
}

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> atEndNoWrite [
	"Demonstrate the atEnd operation when no writes have been performed"
	<gtExample>
	| stream |

	stream := self sampleStream.
	self deny: stream atEnd.
	self assert: (stream next: 64) equals: self string64.
	self assert: stream atEnd
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> nextPutAllStartingAt [
	<gtExample>
	| stream |

	stream := PharoLinkReadFileWriteStream
		readOnly: String new readStream 
		readOnlyLimit: 0
		readWrite: (ReadWriteStream with: String new).
	
	stream next: 5 putAll: '--012345--' startingAt: 3.
	stream next: 5 putAll: '0123456789XX' startingAt: 6. 
	stream next: 5 putAll: '--012345--' startingAt: 3.
	stream next: 5 putAll: '0123456789XX' startingAt: 6.
	stream position: 0.
	self assert: (stream next: 20) equals: '01234567890123456789'
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> peek [
	<gtExample>
	| stream |

	stream := PharoLinkReadFileWriteStream
		readOnly: '0123456789' readStream 
		readOnlyLimit: 10
		readWrite: (ReadWriteStream with: String new).

	'0123456789' do: [ :each |
		self deny: stream atEnd.
		self assert: stream peek equals: each.
		self assert: stream next equals: each ].
	self assert: stream atEnd.
	self assert: stream peek isNil.
	self assert: stream next isNil.
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> readOverBoundary [
	"Demonstrate reading a portion of the stream that starts within the readOnly stream and reads part of the readWrite stream"
	<gtExample>
	| stream |

	stream := self sampleStream.
	stream setToEnd.
	stream next: 15 putAll: '9876543210ABCDEF' startingAt: 1.
	stream position: 60.
	self assert: (stream next: 15) equals: '89+/9876543210A'.
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> readReadOnly [
	"Demonstrate reading a portion of the stream that is fully contained within the readOnly stream"
	<gtExample>
	| stream |

	stream := self sampleStream.
	stream position: 10.
	self assert: (stream next: 5) equals: 'KLMNO'.
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> readReadWrite [
	"Demonstrate reading a portion of the stream that is fully contained within the readWrite stream"
	<gtExample>
	| stream |

	stream := self sampleStream.
	stream setToEnd.
	stream next: 15 putAll: '9876543210ABCDEF' startingAt: 1.
	stream position: 64.
	self assert: (stream next: 5) equals: '98765'.
]

{ #category : #private }
PharoLinkReadFileWriteStreamExamples >> readWriteStreamOn: aCharacterReadStream [
	| virtual |

	virtual := PharoLinkSourcesReadWriteStream empty.
	^ SourceFileBufferedReadWriteStream on:
		(PharoLinkReadFileWriteStream
			readOnly: aCharacterReadStream
			readOnlyLimit: aCharacterReadStream size
			readWrite: virtual)
]

{ #category : #private }
PharoLinkReadFileWriteStreamExamples >> sampleStream [ 
	"Answer a stream with known readOnly contents"
	<gtExample>

	readOnlyStream := self string64 readStream.
	readWriteStream := ReadWriteStream with: String new.
	^ PharoLinkReadFileWriteStream
		readOnly: readOnlyStream 
		readOnlyLimit: 64
		readWrite: readWriteStream.
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> setToEnd [
	"Demonstrate setting the stream to the end and writing a character"
	<gtExample>
	| stream |

	stream := self sampleStream.
	
	stream setToEnd.
	
	stream nextPutAll: 'A'.
	stream flush.

	stream position: 0.
	self assert: stream upToEnd equals: self string64, 'A'.

]

{ #category : #private }
PharoLinkReadFileWriteStreamExamples >> string64 [
	"Answer a 64 character long string with known content"

	^ String withAll: ($A to: $Z) , ($a to: $z) , ($0 to: $9) , #($+ $/).
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testBuffering [
	<gtExample>
	| stream |
	stream := self readWriteStreamOn: '01234567890123456789' readStream.
	stream sizeBuffer: 8.
	self deny: stream atEnd.
	self assert: (stream next: 10) equals: '0123456789'.
	self deny: stream atEnd.
	self assert: (stream next: 10) equals: '0123456789'.
	self assert: stream atEnd	
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testReadInto [
	<gtExample>
	| stream buffer count |
	stream := self readWriteStreamOn: '0123456789' readStream.
	stream sizeBuffer: 8.
	buffer := String new: 6 withAll: Character space.
	stream skip: 1.
	stream readInto: buffer startingAt: 4 count: 3.
	self assert: buffer equals: '   123'.
	stream readInto: buffer startingAt: 1 count: 3.
	self assert: buffer equals: '456123'.
	count := stream readInto: buffer startingAt: 1 count: 100.
	self assert: count equals: 3.
	self assert: buffer equals: '789123'	 
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testReadIntoLarger [
	<gtExample>
	| stream buffer count |
	stream := self readWriteStreamOn: '0123456789' readStream.
	stream sizeBuffer: 4.
	buffer := String new: 10.
	count := stream readInto: buffer startingAt: 1 count: 10.
	self assert: count equals: 10.
	self assert: buffer equals: '0123456789'	 
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testReadUpTo [
	<gtExample>
	| stream |
	stream := self readWriteStreamOn: '0123456789' readStream.
	stream sizeBuffer: 8.
	self assert: (stream upTo: $5) equals: '01234'.
	self assert: stream upToEnd equals: '6789'.
	self assert: stream atEnd
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testReadUpToEnd [
	<gtExample>
	| stream |
	stream := self readWriteStreamOn: '0123456789' readStream.
	stream sizeBuffer: 4.
	stream next: 2.
	self assert: stream upToEnd equals: '23456789'.
	self assert: stream atEnd
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testSetAtEnd [
	<gtExample>
	| stream |

	stream := self readWriteStreamOn: '0123456789' utf8Encoded readStream.
	stream setToEnd.
	stream nextPut: $A asciiValue.
	stream flush.
	stream position: 0.
	
	self assert: stream upToEnd utf8Decoded equals: '0123456789A'.

]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testWriting [
	<gtExample>
	| bufferedStream |

	bufferedStream := self readWriteStreamOn: ByteArray new readStream.
	0 to: 9 do: [ :each | bufferedStream nextPut: (Character digitValue: each) asciiValue ].
	bufferedStream flush.
	bufferedStream position: 0.

	self assert: bufferedStream upToEnd utf8Decoded equals: '0123456789'
]

{ #category : #examples }
PharoLinkReadFileWriteStreamExamples >> testWritingOverflow [
	<gtExample>
	| bufferedStream |
	
	bufferedStream := self readWriteStreamOn: ByteArray new writeStream.
	bufferedStream sizeBuffer: 8.
	0 to: 9 do: [ :each | bufferedStream nextPut: (Character digitValue: each) asciiValue ].
	bufferedStream nextPutAll: '0123' utf8Encoded; nextPutAll: '4567' utf8Encoded; nextPutAll: '89' utf8Encoded.
	bufferedStream nextPutAll: '0123456789' utf8Encoded; nextPutAll: '0123456789' utf8Encoded.
	bufferedStream flush.
	bufferedStream position: 0.
		
	self assert: bufferedStream upToEnd equals: '0123456789012345678901234567890123456789' utf8Encoded
]
