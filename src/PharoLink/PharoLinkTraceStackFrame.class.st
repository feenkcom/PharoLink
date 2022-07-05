Class {
	#name : #PharoLinkTraceStackFrame,
	#superclass : #DoubleLink,
	#instVars : [
		'ordinal',
		'displayString',
		'methodName',
		'blockSource'
	],
	#category : #'PharoLink-ExceptionAnalysis'
}

{ #category : #comparing }
PharoLinkTraceStackFrame >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ methodName = anObject methodName and: [ blockSource = anObject blockSource ]
]

{ #category : #converting }
PharoLinkTraceStackFrame >> asFrameWithChildren [

	^ PharoLinkTraceStackFrameWithChildren new frame: self
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> blockSource [

	^ blockSource
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> blockSource: anObject [

	blockSource := anObject
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> displayString [

	^ displayString
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> displayString: anObject [

	displayString := anObject
]

{ #category : #comparing }
PharoLinkTraceStackFrame >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ methodName hash bitXor: blockSource hash
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> line [

	^ nil
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> methodClassName [
	"Answer the class name of the class containing the receiver's method"
	| separatorIndex superIndex |

	separatorIndex := methodName indexOfSubCollection: '>>'.
	self assert: separatorIndex > 0.

	"If the method belongs to a superclass, answer the superclass"
	(superIndex := methodName indexOf: $() > 0 ifTrue:
		[ ^ methodName copyFrom: superIndex+1 to: (methodName indexOf: $))-1 ].
	^ methodName copyFrom: 1 to: separatorIndex-1.
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> methodName [

	^ methodName
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> methodName: anObject [

	methodName := anObject
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> methodSelectorName [
	"Answer the selector name of the receiver's method"
	| separatorIndex |

	separatorIndex := methodName indexOfSubCollection: '>>'.
	self assert: separatorIndex > 0.

	^ methodName copyFrom: separatorIndex+2 to: methodName size.
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> ordinal [

	^ ordinal
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> ordinal: anObject [

	ordinal := anObject
]

{ #category : #printing }
PharoLinkTraceStackFrame >> printOn: aStream [

	displayString
		ifNil: [ super printOn: aStream ]
		ifNotNil: [ aStream << displayString ]
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> sourceText [
	| text selector |

	blockSource ifNotNil: [ ^ blockSource ].

	selector := self methodSelectorName.
	selector = #DoIt ifTrue: [ ^ '<DoIt source unavailable>' ].
	text := [ (self application newCommandFactory
		<< (self methodClassName, ' >> #', selector);
		sendAndWait) sourceCode ]
			on: Error
			do: [ '<unavailable>' ].
	^ text
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> value [

	^ self
]

{ #category : #accessing }
PharoLinkTraceStackFrame >> value: anObject [

	self error: self class name, ' is its own value'.
]
