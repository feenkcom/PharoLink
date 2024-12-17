Class {
	#name : #PharoLinkRegistryUnknownIdSignal,
	#superclass : #PharoLinkServerSignal,
	#instVars : [
		'unknownId',
		'isOld'
	],
	#category : #'PharoLink-Registry'
}

{ #category : #accessing }
PharoLinkRegistryUnknownIdSignal >> isOld [
	^ isOld
]

{ #category : #accessing }
PharoLinkRegistryUnknownIdSignal >> isOld: anObject [
	isOld := anObject
]

{ #category : #accessing }
PharoLinkRegistryUnknownIdSignal >> unknownId [
	^ unknownId
]

{ #category : #accessing }
PharoLinkRegistryUnknownIdSignal >> unknownId: anObject [
	unknownId := anObject
]
