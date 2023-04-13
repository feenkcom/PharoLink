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

{ #category : #printing }
PharoLinkErrorRequestSignal >> printOneLineContentsOn: aStream [
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	dictionary ifNil: [ ^ self ].
	aStream cr.
	dictionary keysAndValuesDo: [ :key :value |
		aStream 
			tab;
			print: key;
			<< ' -> ';
			print: value;
			cr ]
]
