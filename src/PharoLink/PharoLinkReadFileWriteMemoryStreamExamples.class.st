Class {
	#name : #PharoLinkReadFileWriteMemoryStreamExamples,
	#superclass : #Object,
	#instVars : [
		'resources'
	],
	#category : #'PharoLink-Examples'
}

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> assert: aBlock signals: aClass [
	| signaled |
	signaled := false.
	aBlock
		on: aClass
		do: [ signaled := true ].
	self assert: signaled
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> cleanUp [

	self class removeSelector: #blub.
	PharoFilesOpener reset.
	SourceFiles ensureOpen
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> countSourceWriteStreams [

	^ File registry count: [ :e | 
		  ((e fullName endsWith: '.changes') or: [ 
			   e fullName endsWith: '.sources' ]) and: [ 
			  e instVarNamed: #forWrite ] ]
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> readFileWriteMemorySourceFileOpenOn: aFileReference [

	"Creates and opens a new source file reading from file, writing to memory. Should be closed to release the file handle."

	| fileSystem file |
	fileSystem := FileSystem memory workingDirectory.
	file := fileSystem / UUIDGenerator next asString.
	file createFile.
	^ (PharoLinkReadFileWriteMemorySourceFile
		   on: aFileReference
		   potentialLocations: { aFileReference parent })
		  initializeVirtual: file readOnlyLimit: aFileReference size;
		  tryOpenReadOnly: false;
		  yourself
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> writeFileReadMemory [

	"Writing changes into the file of the RFWM source file should not change its file stream, as it is capped at the size of the file at the time or creation."

	<gtExample>
	<after: #cleanUp>
	| stream size |
	stream := self readFileWriteMemorySourceFileOpenOn:
		          SourceFiles changesFileStream path asFileReference.
	size := SourceFiles changesFileStream size.
	self assert: stream size equals: size.
	self class compile: 'blub
		| named |
		named := 1.
		^ named'.
	self assert: stream size equals: size.
	self class removeSelector: #blub.
	self assert: stream size equals: size.
	stream close.
	^ stream
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> writeMemoryReadMemory [

	"With RFWM source files, changes should not be written to disk. Therefore, the changes file size should be unchanged, yet the sources should be accessible through memory."

	<gtExample>
	<after: #cleanUp>
	| source method size sources changes streamsBefore streamsAfter |
	size := SourceFiles changesFileStream size.
	source := 'blub
		| named |
		named := 1.
		^ named'.
	sources := PharoFilesOpener default sourcesName asFileReference.
	changes := PharoFilesOpener default changesName asFileReference.
	"close sources"
	streamsBefore := self countSourceWriteStreams.
	SourceFiles close.
	streamsAfter := self countSourceWriteStreams.
	self
		assert: streamsBefore - streamsAfter = 1
		description:
		'closing sources and garbage-collect should remove a write stream'.
	streamsBefore := streamsAfter.
	"reopen sources as RFWM"
	PharoLinkFilesOpener install.
	SourceFiles ensureOpen.
	self assert: (SourceFiles changesFileStream isKindOf:
			 PharoLinkReadFileWriteMemorySourceFile).
	self assert: (SourceFiles sourcesFileStream isKindOf:
			 PharoLinkReadFileWriteMemorySourceFile).
	streamsAfter := self countSourceWriteStreams.
	self
		assert: streamsBefore = streamsAfter
		description: 'opening RFWM sources should not add write streams'.
	streamsBefore := streamsAfter.
	"compile should produce method with source in RFWM..."
	self class compile: source.
	method := self class compiledMethodAt: #blub.
	self assert: method hasSourceCode.
	self assert: method sourceCode equals: source.
	streamsAfter := self countSourceWriteStreams.
	self
		assert: streamsBefore = streamsAfter
		description: 'compiling should not add write streams'.
	"...and lose said source"
	PharoFilesOpener reset.
	SourceFiles ensureOpen.
	self assert: method hasSourceCode not.
	self
		assert: SourceFiles changesFileStream size = size
		description: 'RFWM should leave file untouched'.
	^ method
]
