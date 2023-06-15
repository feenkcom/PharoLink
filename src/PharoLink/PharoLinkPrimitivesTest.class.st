Class {
	#name : #PharoLinkPrimitivesTest,
	#superclass : #TestCase,
	#category : #'PharoLink-Tests'
}

{ #category : #tests }
PharoLinkPrimitivesTest >> testArray [
	"Arrays are primitives if all their elements are primitives."

	self deny: { nil. 0. true. } isPharoLinkPrimitive.
	self assert: { nil. 0. true. } canBePharoLinkPrimitive.
	self deny: { nil. self. } canBePharoLinkPrimitive.
]

{ #category : #tests }
PharoLinkPrimitivesTest >> testBooleans [
	"Booleans are primitives."

	self assert: true isPharoLinkPrimitive.
	self assert: false isPharoLinkPrimitive.

]

{ #category : #tests }
PharoLinkPrimitivesTest >> testDictionary [
	"Dictionaries are primitives if all their keys and values are primitives."
	| dict |

	dict := Dictionary new
		at: 1 put: true;
		at: 2 put: { 1 -> { 3. 4. } } asDictionary;
		yourself.
	self deny: dict isPharoLinkPrimitive.
	self assert: dict canBePharoLinkPrimitive.
	dict at: 3 put: { self. }.
	self deny: dict canBePharoLinkPrimitive.
]

{ #category : #tests }
PharoLinkPrimitivesTest >> testNil [
	"nil is a primitives."

	self assert: nil isPharoLinkPrimitive.

]

{ #category : #tests }
PharoLinkPrimitivesTest >> testNumbers [
	"Integers and Floats are considered primitives.
	Fractions aren't."

	self assert: 5 isPharoLinkPrimitive.
	self assert: 5.5 isPharoLinkPrimitive.
	self deny: (2/3) isPharoLinkPrimitive.
]

{ #category : #tests }
PharoLinkPrimitivesTest >> testStrings [
	"All strings are considered primitives."

	self assert: 'hello, world' isPharoLinkPrimitive.
	self assert: 'héllo, world' isPharoLinkPrimitive.

]
