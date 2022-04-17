Class {
	#name : #PharoLinkReadFileWriteMemoryExamples,
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
PharoLinkReadFileWriteMemoryExamples >> atEndNoWrite [
	"Demonstrate the atEnd operation when no writes have been performed"
	<gtExample>
	| stream |

	stream := self sampleStream.
	self deny: stream atEnd.
	self assert: (stream next: 64) equals: self string64.
	self assert: stream atEnd
]

{ #category : #examples }
PharoLinkReadFileWriteMemoryExamples >> nextPutAllStartingAt [
	<gtExample>
	| stream |

	stream := PharoLinkReadFileWriteMemoryStream
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
PharoLinkReadFileWriteMemoryExamples >> peek [
	<gtExample>
	| stream |

	stream := PharoLinkReadFileWriteMemoryStream
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
PharoLinkReadFileWriteMemoryExamples >> readOverBoundary [
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
PharoLinkReadFileWriteMemoryExamples >> readReadOnly [
	"Demonstrate reading a portion of the stream that is fully contained within the readOnly stream"
	<gtExample>
	| stream |

	stream := self sampleStream.
	stream position: 10.
	self assert: (stream next: 5) equals: 'KLMNO'.
]

{ #category : #examples }
PharoLinkReadFileWriteMemoryExamples >> readReadWrite [
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
PharoLinkReadFileWriteMemoryExamples >> sampleStream [ 
	"Answer a stream with known readOnly contents"
	<gtExample>

	readOnlyStream := self string64 readStream.
	readWriteStream := ReadWriteStream with: String new.
	^ PharoLinkReadFileWriteMemoryStream
		readOnly: readOnlyStream 
		readOnlyLimit: 64
		readWrite: readWriteStream.
]

{ #category : #examples }
PharoLinkReadFileWriteMemoryExamples >> setToEnd [
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
PharoLinkReadFileWriteMemoryExamples >> string64 [
	"Answer a 64 character long string with known content"

	^ String withAll: ($A to: $Z) , ($a to: $z) , ($0 to: $9) , #($+ $/).
]
