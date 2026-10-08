Class {
	#name : #PharoLinkReadFileWriteOnDiskSourceFileArrayExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'changesFile',
		'sourceFileArray'
	],
	#category : #'PharoLink-Examples'
}

{ #category : #'private - helpers' }
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> cleanUp [

	sourceFileArray ifNotNil:
		[ sourceFileArray close ].
	changesFile ifNotNil:
		[ changesFile ensureDelete ].
]

{ #category : #private }
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> emptySourceFileArray [
	"Answer a SourceFileArray with the changes file set to a temporary file.
	We have to use an on-disk file as the MemoryFileSystem assumes that the contents of the file will never change over the lifetime of a ReadStream."
	<gtExample>
	<after: #cleanUp>

	changesFile := FileReference newTempFilePrefix: self class name asString suffix: '.changes'.
	sourceFileArray := SourceFileArray new.
	sourceFileArray changesFileStream: (PharoLinkOnDiskFilesOpener new 
		changesFilename: changesFile;
		changesFileOrNil).
	^ sourceFileArray.
]

{ #category : #examples }
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> sourcesFilename [
	"Confirm that the default sources file is used"
	<gtExample>

	self assert: PharoLinkOnDiskFilesOpener new sourcesFilename fullName
		equals: Smalltalk sourcesName
]

{ #category : #examples }
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> testForkedRead [
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
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> testForkedWrite [
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
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> testReadStreamAtFileIndexAtPosition [
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
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> testRemoteStringReadsInGivenSourceFileArray [
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
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> testRemoteStringWritesInGivenSourceFileArray [
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
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> testWriteSourceWritesInGivenSourceFileArrayWithFlushDefering [
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
