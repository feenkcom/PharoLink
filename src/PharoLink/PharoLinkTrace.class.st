Class {
	#name : #PharoLinkTrace,
	#superclass : #Object,
	#instVars : [
		'traceString',
		'stackFrames'
	],
	#category : #'PharoLink-ExceptionAnalysis'
}

{ #category : #private }
PharoLinkTrace >> blockStackFrameFromStream: stream [
	"Answer a stack frame"
	| separatorIndex blockText methodName |

	self assert: stream peek = $[.

	blockText := ''.
	[ separatorIndex := stream positionOfSubCollection: '] in '.
	self assert: separatorIndex > 0.
	blockText := blockText, (stream next: (separatorIndex - stream position)) ] doWhileTrue:
		[ stream next: 4.
		stream peek = $[ ].
	methodName := stream nextLine.
	^ PharoLinkTraceStackFrame new
		displayString: blockText, ' in ', methodName;
		methodName: methodName;
		blockSource: blockText.
]

{ #category : #private }
PharoLinkTrace >> methodStackFrameFromStream: stream [
	"Answer a stack frame"
	| methodName |

	self assert: stream peek ~= $[.

	methodName := stream nextLine.
	^ PharoLinkTraceStackFrame new
		displayString: methodName;
		methodName: methodName.
]

{ #category : #accessing }
PharoLinkTrace >> stackFrames [
	"Answer a ordered collection of stack frames.
	This is called many times by the debugger, so cache"
	| ordinal stream whiteSpace frame |

	^ stackFrames ifNil:
		[ ordinal := 1.
		stackFrames := DoubleLinkedList new.
		stream := traceString readStream.
		whiteSpace := { Character space. Character tab. }.
		[ stream atEnd ] whileFalse:
			[ [ whiteSpace includes: stream peek ] whileTrue:
				[ stream next ].
			frame := stream peek = $[
				ifTrue: [ self blockStackFrameFromStream: stream ]
				ifFalse: [ self methodStackFrameFromStream: stream ].
			frame ordinal: ordinal.
			stackFrames add: frame.
			ordinal := ordinal + 1 ].
		stackFrames ].
]

{ #category : #accessing }
PharoLinkTrace >> traceString [

	^ traceString
]

{ #category : #accessing }
PharoLinkTrace >> traceString: anObject [

	traceString := anObject
]
