Class {
	#name : #PharoLinkReadFileWriteStreamSourceFile,
	#superclass : #SourceFile,
	#instVars : [
		'virtual',
		'readOnlyLimit'
	],
	#category : #'PharoLink-Global'
}

{ #category : #testing }
PharoLinkReadFileWriteStreamSourceFile >> closed [
	^ super closed or:
		[ virtual isNil or: [ virtual closed ] ]
]

{ #category : #accessing }
PharoLinkReadFileWriteStreamSourceFile >> initializeVirtual: aReadWriteStream readOnlyLimit: anInteger [

	virtual := aReadWriteStream.
	readOnlyLimit := anInteger
]

{ #category : #accessing }
PharoLinkReadFileWriteStreamSourceFile >> readOnlyCopy [

	^ (self species on: path potentialLocations: potentialLocations)
		  initializeVirtual: virtual readOnlyLimit: readOnlyLimit;
		  tryOpenReadOnly: true;
		  yourself
]

{ #category : #accessing }
PharoLinkReadFileWriteStreamSourceFile >> tryOpenReadOnly: readOnly [
	| basename |

	basename := path asFileReference basename.
	"Open a read write stream only if read only access was not requested.
	We need to create the encoding and buffering streams manually because we need a read write stream."
	virtual closed ifTrue:
		[ virtual := virtual asOpenStream ].
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
		^ self ].
]
