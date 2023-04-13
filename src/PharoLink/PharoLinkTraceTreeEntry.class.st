Class {
	#name : #PharoLinkTraceTreeEntry,
	#superclass : #Object,
	#instVars : [
		'frame',
		'traces'
	],
	#category : #'PharoLink-ExceptionAnalysis'
}

{ #category : #accessing }
PharoLinkTraceTreeEntry >> frame [

	^ frame
]

{ #category : #accessing }
PharoLinkTraceTreeEntry >> frame: anObject [

	frame := anObject
]

{ #category : #initialization }
PharoLinkTraceTreeEntry >> initialize [

	super initialize.
	traces := Dictionary new.
]

{ #category : #accessing }
PharoLinkTraceTreeEntry >> traces [

	^ traces
]
