Class {
	#name : #PharoLinkTraceGroup,
	#superclass : #Object,
	#traits : 'TGtGroup',
	#classTraits : 'TGtGroup classTrait',
	#instVars : [
		'traces',
		'rootEntry'
	],
	#category : #'PharoLink-ExceptionAnalysis'
}

{ #category : #adding }
PharoLinkTraceGroup >> addToTreeTrace: trace [
	| currentEntry |

	currentEntry := rootEntry.
	trace stackFrames do: [ :frame |
		currentEntry := currentEntry atFrame: frame ].
]

{ #category : #accessing }
PharoLinkTraceGroup >> items [
	^ traces
]

{ #category : #private }
PharoLinkTraceGroup >> populateTree [

	rootEntry := PharoLinkTraceStackFrameWithChildren new.
	self traces do: [ :trace | self addToTreeTrace: trace ]
]

{ #category : #accessing }
PharoLinkTraceGroup >> traces [

	^ traces
]

{ #category : #accessing }
PharoLinkTraceGroup >> traces: aCollection [

	traces := aCollection.
	self populateTree.
]

{ #category : #initialization }
PharoLinkTraceGroup >> traceStrings: aCollection [

	self traces: (aCollection collect: [ :string |
		PharoLinkTrace new traceString: string ]).

]
