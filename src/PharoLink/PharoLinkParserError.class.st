Class {
	#name : #PharoLinkParserError,
	#superclass : #Error,
	#instVars : [
		'source',
		'position',
		'parser'
	],
	#category : #'PharoLink-ErrorHandling'
}

{ #category : #ui }
PharoLinkParserError >> gtSourceFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Source';
		priority: 10;
		text: [ self highlightedSourceText ]
]

{ #category : #ui }
PharoLinkParserError >> highlightedSourceText [
	"Answer the source as text, highlighting the start of the error"
	| text |

	source ifNil: [ ^'' asRopedText ].
	text := source asRopedText.
	position ifNil: [ ^text ].
	(text from: position to: text size) foreground: Color red.
	^ text
]

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
