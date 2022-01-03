Class {
	#name : #PharoLinkReadFileWriteMemoryStreamExamples,
	#superclass : #Object,
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
PharoLinkReadFileWriteMemoryStreamExamples >> readFileWriteMemorySourceFileOpenOn: aFileReference [

	"Creates and opens a new source file reading from file, writing to memory. Should be closed to release the file handle."

	| virtual |
	virtual := FileSystem memory workingDirectory
	           / UUIDGenerator next asString.
	virtual createFile.
	^ (PharoLinkReadFileWriteMemorySourceFile
		   on: aFileReference
		   potentialLocations: { aFileReference parent })
		  initializeVirtual: virtual
		  readOnlyLimit: aFileReference asFileReference size;
		  tryOpenReadOnly: false;
		  yourself
]

{ #category : #accessing }
PharoLinkReadFileWriteMemoryStreamExamples >> writeFileReadMemory [

	"Writing changes into the file of the RFWM source file should not change its file stream, as it is capped at the size of the file at the time or creation."

	<gtExample>
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
	| source method size sources changes streams |
	size := SourceFiles changesFileStream size.
	source := 'blub
		| named |
		named := 1.
		^ named'.
	sources := PharoFilesOpener default sourcesName asFileReference.
	changes := PharoFilesOpener default changesName asFileReference.
	"release source files"
	SourceFiles close.
	"acquire source files for write"
	streams := { 
		           sources binaryWriteStream.
		           changes binaryWriteStream }.
	"ensure that opening them for write fails"
	self
		assert: [ sources binaryWriteStream close ]
		signals: CannotDeleteFileException.
	self
		assert: [ changes binaryWriteStream close ]
		signals: CannotDeleteFileException.
	[ 
	PharoLinkFilesOpener install.
	SourceFiles ensureOpen.
	self assert: (SourceFiles changesFileStream isKindOf:
			 PharoLinkReadFileWriteMemorySourceFile).
	self assert: (SourceFiles sourcesFileStream isKindOf:
			 PharoLinkReadFileWriteMemorySourceFile).
	self class compile: source.
	method := self class compiledMethodAt: #blub.
	self assert: method hasSourceCode.
	self assert: method sourceCode equals: source ] ensure: [ 
		streams do: #close.
		PharoFilesOpener reset.
		SourceFiles ensureOpen ].
	self assert: method hasSourceCode not.
	self assert: SourceFiles changesFileStream size equals: size.
	self class removeSelector: #blub.
	^ method
]
