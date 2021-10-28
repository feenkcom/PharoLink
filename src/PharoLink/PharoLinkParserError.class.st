Class {
	#name : #PharoLinkParserError,
	#superclass : #Error,
	#instVars : [
		'source',
		'position',
		'parser'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : #accessing }
PharoLinkParserError >> parser [
	^ parser
]

{ #category : #accessing }
PharoLinkParserError >> parser: anObject [
	parser := anObject
]

{ #category : #accessing }
PharoLinkParserError >> position [
	^ position
]

{ #category : #accessing }
PharoLinkParserError >> position: anObject [
	position := anObject
]

{ #category : #accessing }
PharoLinkParserError >> source [
	^ source
]

{ #category : #accessing }
PharoLinkParserError >> source: anObject [
	source := anObject
]
