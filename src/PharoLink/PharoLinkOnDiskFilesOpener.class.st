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
PharoLinkOnDiskFilesOpener class >> defaultBasename [

	^ 'detached.', GtOsSystemInfo current currentProcessId asString, '.changes'
]

{ #category : #initialization }
PharoLinkOnDiskFilesOpener class >> initialize [

	"Prority is one less than SourceFileArray's handler, as we want to influence it."

	SessionManager default
		register: (ClassSessionHandler forClassNamed: self name)
		inCategory: SessionManager default systemCategory
		atPriority: SessionManager default defaultPriority - 1
]

{ #category : #'startup - shutdown' }
PharoLinkOnDiskFilesOpener class >> install [
	Default := self new
]

{ #category : #'startup - shutdown' }
PharoLinkOnDiskFilesOpener class >> installIn: aFileReference [

	Default := self new
		changesFilename: (aFileReference asFileReference / self defaultBasename)
]

{ #category : #'startup - shutdown' }
PharoLinkOnDiskFilesOpener class >> startUp: isStarting [
	"If starting, install the receiver in the specified directory.
	The directory must exist prior to imgage startup."
	| arguments index |

	isStarting ifFalse: [ ^ self ].
	arguments := Smalltalk argumentsStartingAtIndex: 0.
	(arguments includes: '--detachChanges')
		ifTrue: [ ^ self install ].
	index := arguments indexOf: '--detachChangesDir'.
	index > 0 ifTrue:
		[ ^ self installIn: (arguments at: index + 1) ].
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
		[ changesFilename := self changesName asFileReference parent / self class defaultBasename ].
]

{ #category : #accessing }
PharoLinkOnDiskFilesOpener >> changesFilename: aFileReference [

	changesFilename := aFileReference
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
