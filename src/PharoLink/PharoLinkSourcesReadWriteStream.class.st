Class {
	#name : #PharoLinkSourcesReadWriteStream,
	#superclass : #ReadWriteStream,
	#category : 'PharoLink-Global'
}

{ #category : #requirements }
PharoLinkSourcesReadWriteStream class >> empty [

	^ self on: ByteArray new.
]

{ #category : #private }
PharoLinkSourcesReadWriteStream >> discardBuffer [
	"Do nothing - the receiver's collection is the authoritive source"
]
