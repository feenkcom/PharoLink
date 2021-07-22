"
This class contains tests.

#testSimpleLambda and #testSimpleMapping from JSLink / PythonBridge are not yet implemented as it isn't clear yet what the best way to implement lambdas is.
"
Class {
	#name : #PharoLinkSimpleApplicationTest,
	#superclass : #PharoLinkApplicationTest,
	#category : 'PharoLink-Tests'
}

{ #category : #tests }
PharoLinkSimpleApplicationTest >> testDoubleRetrieveValue [
	| promise cf |

	cf := application newCommandFactory.
	cf << '1+2'.
	promise := cf send.
	self assert: promise waitForValue equals: 3.
	cf << '3*4'.
	promise := cf send.
	self assert: promise waitForValue equals: 12
]

{ #category : #tests }
PharoLinkSimpleApplicationTest >> testSimpleLambda [
	"PharoLink doesn't yet have first class support for BlockClosures.
	Simulate by assigning to a variable and binding."
	| cf bc binding value |

	cf := application newCommandFactory.
	bc := cf
				<< '[ :x | x + 1 ]';
				sendAndWait.
	binding := PharoLinkBinding key: 'bc' wrap: bc.
	value := cf 
		addBinding: binding;
		<< 'bc value: 41';
		sendAndWait.
	self assert: value equals: 42.
]
