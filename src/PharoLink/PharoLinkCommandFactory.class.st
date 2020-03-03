Class {
	#name : #PharoLinkCommandFactory,
	#superclass : #LanguageLinkCommandFactory,
	#category : #'PharoLink-Execution'
}

{ #category : #initialization }
PharoLinkCommandFactory >> setNotifyToInstruction: aLLInstruction [
	| node notifyNode rewriter |

	node := RBParser parseExpression: aLLInstruction pharoLinkFormattedCode.
	notifyNode := node isSequence ifTrue: 
		[ self setNotifyToInstructionSequence: node ]
	ifFalse: 
		[ self setNotifyToInstructionStatement: aLLInstruction ].
	"rewriter := RBParseTreeRewriter new.
	bindingsDictionary keysAndValuesDo: [ :key :value |
		rewriter replace: key with: value pharoLinkFormattedCode ].
	rewriter executeTree: notifyNode.
	^ rewriter tree"
	^ notifyNode
]

{ #category : #initialization }
PharoLinkCommandFactory >> setNotifyToInstructionSequence: aRBSequenceNode [
	| lastStatement replacementStatement |

	lastStatement := aRBSequenceNode statements last.
	aRBSequenceNode removeNode: lastStatement.
	replacementStatement := RBParser parseExpression: 
		(String streamContents: [ :stream |
			stream 
				<< 'llCommand notify: (';
				<< lastStatement formattedCode;
				<< ') id: ';
				print: command id. ]).
	aRBSequenceNode addNode: replacementStatement.
	^ aRBSequenceNode 
]

{ #category : #initialization }
PharoLinkCommandFactory >> setNotifyToInstructionStatement: aLLInstruction [

	^ RBParser parseExpression: (String streamContents: [ :stream |
		stream 
			<< 'llCommand notify: (';
			<< aLLInstruction pharoLinkFormattedCode;
			<< ') id: ';
			print: command id. ]).

]
