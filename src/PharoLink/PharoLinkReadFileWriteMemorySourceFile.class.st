Class {
	#name : #PharoLinkReadFileWriteMemorySourceFile,
	#superclass : #SourceFile,
	#instVars : [
		'virtual',
		'readOnlyLimit'
	],
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
PharoLinkReadFileWriteMemorySourceFile >> initializeVirtual: aReadWriteStream readOnlyLimit: anInteger [

	virtual := aReadWriteStream.
	readOnlyLimit := anInteger
]

{ #category : #accessing }
PharoLinkReadFileWriteMemorySourceFile >> readOnlyCopy [

	^ (self species on: path potentialLocations: potentialLocations)
		  initializeVirtual: virtual readOnlyLimit: readOnlyLimit;
		  tryOpenReadOnly: true;
		  yourself
]

{ #category : #accessing }
PharoLinkReadFileWriteMemorySourceFile >> tryOpenReadOnly: readOnly [
	| basename |

	basename := path asFileReference basename.
	"Open a read write stream only if read only access was not requested.
	We need to create the encoding and buffering streams manually because we need a read write stream."
	readOnly ifFalse: [ 
		potentialLocations do: [ :each | 
			stream := SourceFileCharacterReadWriteStream
				on: (SourceFileBufferedReadWriteStream on:
					(PharoLinkReadFileWriteStream
						readOnly: (each asFileReference / basename) binaryReadStream
						readOnlyLimit: readOnlyLimit
						readWrite: virtual))
				encoding: 'utf8'.
			^ self ] ].
	potentialLocations do: [ :each | 
		stream := ZnCharacterReadStream
			on: (PharoLinkReadFileWriteStream
				readOnly: (each asFileReference / basename) binaryReadStream
				readOnlyLimit: readOnlyLimit
				readWrite: virtual)
			encoding: 'utf8'.
		^ self ]
]
