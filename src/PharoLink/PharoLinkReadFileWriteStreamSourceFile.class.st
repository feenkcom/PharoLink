Class {
	#name : #PharoLinkReadFileWriteStreamSourceFile,
	#superclass : #SourceFile,
	#instVars : [
		'readOnlyLimit',
		'extensionFilename'
	],
	#category : 'PharoLink-Global'
}

{ #category : #accessing }
PharoLinkReadFileWriteStreamSourceFile >> initializeExtensionFilename: aFileReference readOnlyLimit: anInteger [

	extensionFilename := aFileReference.
	readOnlyLimit := anInteger
]

{ #category : #accessing }
PharoLinkReadFileWriteStreamSourceFile >> readOnlyCopy [

	^ (self species on: path potentialLocations: potentialLocations)
		  initializeExtensionFilename: extensionFilename readOnlyLimit: readOnlyLimit;
		  tryOpenReadOnly: true;
		  yourself
]

{ #category : #accessing }
PharoLinkReadFileWriteStreamSourceFile >> tryOpenReadOnly: readOnly [
	"Open a read write stream only if read only access was not requested.
	We need to create the encoding and buffering streams manually because we need a read write stream.
	Note that the potentialLocations must have one entry that is known to contain the changes / sources as the extension file will be created if necessary."
	| readOnlyName location |

	readOnlyName := path asFileReference basename.
	location := potentialLocations first.
	readOnly ifFalse: 
		[ stream := SourceFileCharacterReadWriteStream
			on: (SourceFileBufferedReadWriteStream on:
				(PharoLinkReadFileWriteStream
					readOnly: (location asFileReference / readOnlyName) binaryReadStream
					readOnlyLimit: readOnlyLimit
					readWrite: extensionFilename unbufferedBinaryWriteStream))
				encoding: 'utf8'.
		^ self ].

	stream := ZnCharacterReadStream
		on: (PharoLinkReadFileWriteStream
			readOnly: (location asFileReference / readOnlyName) binaryReadStream
			readOnlyLimit: readOnlyLimit
			readWrite: extensionFilename binaryReadStream)
		encoding: 'utf8'.
	^ self.
]
