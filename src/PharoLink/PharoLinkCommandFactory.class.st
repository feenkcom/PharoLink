Class {
	#name : #PharoLinkCommandFactory,
	#superclass : #LanguageLinkCommandFactory,
	#category : #'PharoLink-Execution'
}

{ #category : #bindings }
PharoLinkCommandFactory >> bindingAt: varName put: anObject [
	bindingsDictionary at: varName put: anObject.
	^ anObject
]

{ #category : #bindings }
PharoLinkCommandFactory >> bindingWrap: anObject [
	^ self addBinding: (PharoLinkBinding wrap: anObject)
]

{ #category : #encoding }
PharoLinkCommandFactory >> setBySerialized [
	"Answer the command result by serialized value if possible"

	self << 'PharoLinkAnswerByValue setBySerialized.'.
]

{ #category : #encoding }
PharoLinkCommandFactory >> setByValue [
	"Answer the command result by value if possible"

	self << 'PharoLinkAnswerByValue setByValue.'.
]

{ #category : #encoding }
PharoLinkCommandFactory >> setByValueOnly [
	"Answer the command result by value if possible"

	self << 'PharoLinkAnswerByValue setByValueOnly.'.
]

{ #category : #initialization }
PharoLinkCommandFactory >> setNotifyToInstruction: aLLInstruction [
	| node notifyNode |

	node := RBParser 
		parseExpression: aLLInstruction pharoLinkFormattedCode
		onError: [ :aString :position :parser | 
			PharoLinkParserError new 
				messageText: aString;
				position: position;
				parser: parser;
				source: aLLInstruction pharoLinkFormattedCode;
				signal ].
	notifyNode := node isSequence ifTrue: 
		[ self setNotifyToInstructionSequence: node ]
	ifFalse: 
		"Use the formatted code rather than the supplied string in case a period has been included"
		[ self setNotifyToInstructionStatement: node formattedCode ].
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
