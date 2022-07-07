Class {
	#name : #PharoLinkTraceStackFrameWithChildren,
	#superclass : #Object,
	#instVars : [
		'frame',
		'children'
	],
	#category : #'PharoLink-ExceptionAnalysis'
}

{ #category : #comparing }
PharoLinkTraceStackFrameWithChildren >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ frame = anObject frame
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> addChild: aPharoLinkStackFrameWithChildren [

	children add: aPharoLinkStackFrameWithChildren asFrameWithChildren
]

{ #category : #converting }
PharoLinkTraceStackFrameWithChildren >> asFrameWithChildren [

	^ self
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> atFrame: aFrame [
	"Add aFrame to the receiver's children if necessary and answer the frame from the children"
	| withChildren |

	withChildren := aFrame asFrameWithChildren.
	self addChild: withChildren.
	^ children like: withChildren.
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> children [

	^ children
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> children: anObject [

	children := anObject
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> frame [

	^ frame
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> frame: anObject [

	frame := anObject
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> gtChildrenSummaryFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Child Summary';
		priority: 10;
		items: [ (self withDeepCollect: #children)
			sorted: [ :a :b | a children size > b children size ] ];
		column: 'Frame' text: [ :item | item gtDisplayString ];
		column: 'Child Count' text: [ :item | item children size asString ].
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> gtTreeViewFor: aView [
	<gtView>

	^ aView tree
		title: 'Tree';
		priority: 10;
		items: [ self asArray ];
		children: #children
		
]

{ #category : #comparing }
PharoLinkTraceStackFrameWithChildren >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ frame hash
]

{ #category : #initialization }
PharoLinkTraceStackFrameWithChildren >> initialize [

	super initialize.
	children := Set new.
]

{ #category : #accessing }
PharoLinkTraceStackFrameWithChildren >> printOn: aStream [

	frame printOn: aStream.
]
