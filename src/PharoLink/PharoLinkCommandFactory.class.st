Class {
	#name : #PharoLinkCommandFactory,
	#superclass : #LanguageLinkCommandFactory,
	#category : #'PharoLink-Execution'
}

{ #category : #initialization }
PharoLinkCommandFactory >> setNotifyToInstruction: aLLInstruction [

	| instructionString |

	instructionString := aLLInstruction ifNil:
		[ 'nil' ]
	ifNotNil: [ aLLInstruction isString ifTrue: 
		[ aLLInstruction ]
	ifFalse:
		[ aLLInstruction formattedCode ] ].
	^ RBParser parseExpression: (String streamContents: [ :stream |
		stream 
			<< 'llCommand notify: (';
			<< aLLInstruction;
			<< ') id: ';
			print: command id. ]).

]
