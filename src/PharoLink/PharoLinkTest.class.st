Class {
	#name : #PharoLinkTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'commandFactory'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #private }
PharoLinkTest >> replace: variableDictionary in: pharoExpressionString [
	"Map the variable names in variableDictionary to their registry expression"
	| rewriter |

	rewriter := RBParseTreeRewriter new.
	variableDictionary keysAndValuesDo: [ :varName :proxyObject |
		rewriter
			replace: varName
			with: 'llCommand registry resolve: ', proxyObject id printString ].
	rewriter executeTree: (RBParser parseExpression: pharoExpressionString).
	^ rewriter tree formattedCode
]
