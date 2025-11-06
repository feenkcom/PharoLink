Class {
	#name : #PharoLinkOnDiskFilesOpener,
	#superclass : #PharoFilesOpener,
	#instVars : [
		'changesFilename',
		'sourcesFilename'
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
PharoLinkOnDiskFilesOpener >> changesFileOrNil [
	| changes |

	changes := self changesName asFileReference.
	^ (PharoLinkReadFileWriteStreamSourceFile
		   on: changes
		   potentialLocations: { changes parent })
		  initializeExtensionFilename: self changesFilename readOnlyLimit: changes size;
		  tryOpenReadOnly: false;
		  yourself
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesFilename [
	"Answer the FileReference when stored on-disk.
	This should normally be at the same location as the original changes file,
	however it may be overwritten for testing."

	^ changesFilename ifNil: 
		[ changesFilename := self changesName asFileReference parent / ('detached.', GtOsSystemInfo current currentProcessId asString, '.changes') ].
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesFilename: anObject [
	changesFilename := anObject
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesFileOrNil [
	| sources |

	sources := self sourcesName asFileReference.
	^ (PharoLinkReadFileWriteStreamSourceFile
		   on: sources
		   potentialLocations: { sources parent })
		  initializeExtensionFilename: self sourcesFilename readOnlyLimit: sources size;
		  tryOpenReadOnly: true;
		  yourself
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesFilename [
	"Answer the FileReference when stored on-disk.
	This should normally be at the same location as the original sources file,
	however it may be overwritten for testing."

	^ sourcesFilename ifNil:
		[ sourcesFilename := self sourcesName asFileReference ]
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> sourcesFilename: anObject [
	sourcesFilename := anObject
]
