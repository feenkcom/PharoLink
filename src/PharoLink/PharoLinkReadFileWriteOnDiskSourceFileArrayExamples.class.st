Class {
	#name : #PharoLinkReadFileWriteOnDiskSourceFileArrayExamples,
	#superclass : #PharoLinkReadFileWriteInMemorySourceFileArrayExamples,
	#instVars : [
		'changesFile',
		'sourceFileArray'
	],
	#category : 'PharoLink-Examples'
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
