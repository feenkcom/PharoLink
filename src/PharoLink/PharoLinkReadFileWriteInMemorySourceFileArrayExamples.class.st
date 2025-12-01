Class {
	#name : #PharoLinkReadFileWriteInMemorySourceFileArrayExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : 'PharoLink-Examples'
}

{ #category : #private }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> emptySourceFileArray [
	| sfa |

	sfa := SourceFileArray new.
	sfa changesFileStream: (PharoLinkInMemoryFilesOpener new changesFileOrNil).
	^ sfa
]

{ #category : #examples }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> testForkedRead [
	<gtExample>
	| originalString remoteString readSemaphore readString testSemaphore |

	originalString := '"test"'.
	remoteString := nil.
	readSemaphore := Semaphore new.
	testSemaphore := Semaphore new.

	[	readSemaphore wait.

		"Read the string that was written in other process."
		readString := remoteString string.
		testSemaphore signal 
		] fork.

	"Write the string, that will be read in other process."
	remoteString := self emptySourceFileArray remoteStringForNewString: originalString.

	readSemaphore signal.
	testSemaphore wait.
	
	self assert: readString equals: originalString.
]

{ #category : #examples }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> testForkedWrite [
	<gtExample>
	| originalString remoteString readSemaphore readString testSemaphore |

	originalString := '"test"'.
	remoteString := nil.
	readSemaphore := Semaphore new.
	testSemaphore := Semaphore new.
	
	[	readSemaphore wait.

		"Write the string, that will be read in other process."
		remoteString := self emptySourceFileArray remoteStringForNewString: originalString.

		testSemaphore signal 
		] fork.

	readSemaphore signal.
	testSemaphore wait.

	"Read the string that was written in other process."
	readString := remoteString string.
	
	self assert: readString equals: originalString.
]

{ #category : #examples }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> testReadStreamAtFileIndexAtPosition [
	<gtExample>
	| stream array endPosition string |

	array := self emptySourceFileArray.
	stream := array changesFileStream readOnlyCopy.
	[ stream setToEnd.
	endPosition := stream position ]
		ensure: [ stream close ].
	array deferFlushDuring: [ 
			array
				writeSource: 'source1'
				preamble: 'preamble1'
				onSuccess: [ :arg1 |  ]
				onFail: [ self fail ] ].

	string := array
		readStreamAtFileIndex: 2
		atPosition: endPosition
		ifPresent: [ :rStream | rStream upToEnd ]
		ifAbsent: [ self error: 'Unable to read changes file' ].
	self assert: string equals: 'preamble1source1!'.

	array deferFlushDuring: [ 
			array
				writeSource: 'source2'
				preamble: 'preamble2'
				onSuccess: [ :arg1 |  ]
				onFail: [ self fail ] ].

	string := array
		readStreamAtFileIndex: 2
		atPosition: endPosition+17
		ifPresent: [ :rStream | rStream upToEnd ]
		ifAbsent: [ self error: 'Unable to read changes file' ].
	self assert: string equals: 'preamble2source2!'
]

{ #category : #examples }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> testRemoteStringReadsInGivenSourceFileArray [
	<gtExample>
	| array remoteString readStream |

	array := self emptySourceFileArray.
	remoteString := array remoteStringForNewString: 'test'.
	self assert: remoteString string equals: 'test'.
	self assert: (array fileAt: remoteString sourceFileNumber) equals: array changesFileStream.
	readStream := array changesFileStream.
	readStream position: remoteString position.
	self assert: (ChunkReadStream on: readStream) next equals: 'test'
]

{ #category : #examples }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> testRemoteStringWritesInGivenSourceFileArray [
	<gtExample>
	| array remoteString readStream |

	array := self emptySourceFileArray.
	remoteString := array remoteStringForNewString: 'test'.
	readStream := array changesFileStream.
	readStream position: remoteString position - 1.

	self
		assert: readStream upToEnd
		equals:
			'
test!'
]

{ #category : #examples }
PharoLinkReadFileWriteInMemorySourceFileArrayExamples >> testWriteSourceWritesInGivenSourceFileArrayWithFlushDefering [
	<gtExample>
	| stream array endPosition |
	array := self emptySourceFileArray.
	stream := array changesFileStream readOnlyCopy.
	stream setToEnd.
	endPosition := stream position.
	array deferFlushDuring: [ 
			array
				writeSource: 'some source'
				preamble: 'some preamble'
				onSuccess: [ :arg1 |  ]
				onFail: [ self fail ] ].
	stream := array changesFileStream readOnlyCopy.
	stream position: endPosition.
	self
		assert: stream upToEnd
		equals: 'some preamblesome source!'
]
