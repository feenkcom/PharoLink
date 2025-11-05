Class {
	#name : #PharoLinkOnDiskFilesOpener,
	#superclass : #PharoFilesOpener,
	#instVars : [
		'sourcesVirtual',
		'fileSystem',
		'changesVirtual'
	],
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
PharoLinkOnDiskFilesOpener class >> initialize [

	"Prority is one less than SourceFileArray's handler, as we want to influence it."

	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default systemCategory
		atPriority: SessionManager default defaultPriority - 1
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener class >> install [
	Default := self new
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener class >> startUp: isStarting [

	isStarting ifFalse: [ ^ self ].
	(Smalltalk argumentsInclude: '--detachChanges') 
		ifFalse: [ ^ self ].
	self install.
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesBasename [
	"Answer the basename of the file when stored on-disk"

	^ 'detached.', GtOsSystemInfo current currentProcessId asString, '.changes'
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesFileOrNil [

	| changes |
	changes := self changesName asFileReference.
	^ (PharoLinkReadFileWriteStreamSourceFile
		   on: changes
		   potentialLocations: { changes parent })
		  initializeVirtual: self changesVirtual readOnlyLimit: changes size;
		  tryOpenReadOnly: false;
		  yourself
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesVirtual [

	^ changesVirtual ifNil: 
		[ self changesBasename asFileReference unbufferedBinaryWriteStream ]
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesVirtual: anObject [
	changesVirtual := anObject
]

{ #category : #private }
PharoLinkOnDiskFilesOpener >> sourceFileBasename: aString [ 

	^ SourceFile on: aString asFileReference potentialLocations: { FileLocator workingDirectory resolve }
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesBasename [
	"Answer the basename of the file when stored on-disk"

	^ 'detached.', GtOsSystemInfo current currentProcessId asString, '.sources'
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesFileOrNil [

	| sources |
	sources := self sourcesName asFileReference.
	^ (PharoLinkReadFileWriteStreamSourceFile
		   on: sources
		   potentialLocations: { sources parent })
		  initializeVirtual: self sourcesVirtual readOnlyLimit: sources size;
		  tryOpenReadOnly: true;
		  yourself
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesVirtual [

	^ sourcesVirtual ifNil: 
		[ self sourcesBasename asFileReference unbufferedBinaryWriteStream ]
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesVirtual: anObject [
	sourcesVirtual := anObject
]
