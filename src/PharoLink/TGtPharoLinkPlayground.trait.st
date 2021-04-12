Trait {
	#name : #TGtPharoLinkPlayground,
	#instVars : [
		'gtPlaygroundFilename'
	],
	#category : #'PharoLink-UI'
}

{ #category : #'ui - accessing' }
TGtPharoLinkPlayground >> gtPlaygroundFilename [
	"Answer the filename containing the receiver's source.
	If no action has been performed, use the last saved code.
	If an action has been performed gtPlaygroundFilename will have been set."

	^gtPlaygroundFilename ifNil: 
		[ self gtPlaygroundXdocStore latestFilename ].

]

{ #category : #ui }
TGtPharoLinkPlayground >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		priority: 100;
		text: [ self gtPlaygroundText ];
		styler: self settings parserClass gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				self gtPlaygroundSaveSource: statements.
				result := [ self evaluateSourceSequence: statements ]
					on: PharoLinkRemoteError, PharoLinkParserError
					do: [ :ex | ex ].
				aButton phlow spawnObject: result ].

]

{ #category : #'ui - accessing' }
TGtPharoLinkPlayground >> gtPlaygroundSaveSource: aString [ 
	"Save the supplied source code"

	gtPlaygroundFilename ifNil: 
		[ gtPlaygroundFilename := self gtPlaygroundXdocStore newFile ].

	^ XdWriter new 
				streamingStrategy: (XdStreamingStrategy file: gtPlaygroundFilename);
				authorName: 'PharoLink Playground';
				title: 'Playground Source Code';
				description: 'Playground Source Code';
				text;
				attachment: 'playground.source' text: aString;
				write
]

{ #category : #'ui - accessing' }
TGtPharoLinkPlayground >> gtPlaygroundString [
	"Answer the string to be initially displayed in the playground"
	| sourceFile xDoc |

	sourceFile := self gtPlaygroundFilename.
	sourceFile ifNil: [ ^'' ].

	xDoc := XdReader new 
				streamingStrategy: (XdStreamingStrategy file: sourceFile);
				read.
	^ (xDoc memberNamed: 'playground.source') contents utf8Decoded.

]

{ #category : #'ui - accessing' }
TGtPharoLinkPlayground >> gtPlaygroundText [
	"Answer the formatted text to be initially displayed in the playground"

	^ self gtPlaygroundString asRopedText attributesBuilder
]

{ #category : #'ui - accessing' }
TGtPharoLinkPlayground >> gtPlaygroundXDocStoreKey [
	"Answer the key to be used for storing documents.
	The base class should override this to use a custom key"

	^ self class name
]

{ #category : #'ui - accessing' }
TGtPharoLinkPlayground >> gtPlaygroundXdocStore [
	"Answer the XDoc store for the receiver."

	^ XdKeyDocumentStore forKey: self gtPlaygroundXDocStoreKey
]
