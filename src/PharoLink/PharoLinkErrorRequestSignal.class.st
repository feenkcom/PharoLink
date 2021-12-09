Class {
	#name : #PharoLinkErrorRequestSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'dictionary'
	],
	#category : #'PharoLink-Server'
}

{ #category : #accessing }
PharoLinkErrorRequestSignal >> dictionary [

	^ dictionary
]

{ #category : #accessing }
PharoLinkErrorRequestSignal >> dictionary: anObject [

	dictionary := anObject
]
