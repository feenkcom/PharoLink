Class {
	#name : #PharoLinkFilesOpener,
	#superclass : #PharoFilesOpener,
	#instVars : [
		'sourcesVirtual',
		'fileSystem',
		'changesVirtual'
	],
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
PharoLinkFilesOpener class >> initialize [

	"Prority is one less than SourceFileArray's handler, as we want to influence it."

	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default systemCategory
		atPriority: SessionManager default defaultPriority - 1
]

{ #category : #accessing }
PharoLinkFilesOpener class >> install [
	Default := self new
]

{ #category : #accessing }
PharoLinkFilesOpener class >> startUp: isStarting [

	isStarting ifFalse: [ ^ self ].
	(Smalltalk argumentsInclude: '--detachChangesFromFileSystem') 
		ifFalse: [ ^ self ].
	PharoLinkFilesOpener install.
	EpMonitor current log initializeWith: OmMemoryStore new
	"(CodeImporter fileStream: virtualChanges readStream)
		gtReduceToUnsavedChunks;
		evaluate."
]

{ #category : #accessing }
PharoLinkFilesOpener >> changesFileOrNil [

	| changes |
	changes := super changesFileOrNil path asFileReference.
	^ (PharoLinkReadFileWriteMemorySourceFile
		   on: changes
		   potentialLocations: { changes parent })
		  initializeVirtual: changesVirtual readOnlyLimit: changes size;
		  tryOpenReadOnly: false;
		  yourself
]

{ #category : #accessing }
PharoLinkFilesOpener >> initialize [
	super initialize.

	fileSystem := FileSystem memory.
	sourcesVirtual := fileSystem workingDirectory
	                  / UUIDGenerator next asString.
	sourcesVirtual createFile.
	changesVirtual := fileSystem workingDirectory
	                  / UUIDGenerator next asString.
	changesVirtual createFile.
]

{ #category : #accessing }
PharoLinkFilesOpener >> sourcesFileOrNil [

	| sources |
	sources := super sourcesFileOrNil path asFileReference.
	^ (PharoLinkReadFileWriteMemorySourceFile
		   on: sources
		   potentialLocations: { sources parent })
		  initializeVirtual: sourcesVirtual readOnlyLimit: sources size;
		  tryOpenReadOnly: true;
		  yourself
]
