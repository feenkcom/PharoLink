Class {
	#name : #PharoLinkReadFileWriteOnDiskSourceFileArrayExamples,
	#superclass : #PharoLinkReadFileWriteInMemorySourceFileArrayExamples,
	#category : #'PharoLink-Examples'
}

{ #category : #private }
PharoLinkReadFileWriteOnDiskSourceFileArrayExamples >> emptySourceFileArray [
	"Answer a SourceFileArray with the changes file set to a "
	| changesFile sfa |

	changesFile := FileSystem memory / 'changes.changes'.
	sfa := SourceFileArray new.
	sfa ensureOpen.
	sfa changesFileStream close.
	sfa changesFileStream: (PharoLinkOnDiskFilesOpener new 
		changesVirtual: changesFile unbufferedBinaryWriteStream;
		changesFileOrNil).
	^ sfa
]
