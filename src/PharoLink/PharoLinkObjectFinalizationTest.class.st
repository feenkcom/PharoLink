Class {
	#name : #PharoLinkObjectFinalizationTest,
	#superclass : #PharoLinkApplicationTest,
	#category : #'PharoLink-Tests'
}

{ #category : #tests }
PharoLinkObjectFinalizationTest >> testGCSimpleObj [
	| obj obj2 id inRegistry |

	obj := application newCommandFactory
				sendAndWait: '1 @ 2'.
	id := obj proxyObjectId.
	obj2 := application newCommandFactory
				sendAndWait: (self 
					replace: { 'obj' -> obj } asDictionary
					in: 'obj').
	self assert: obj2 equals: obj.
	inRegistry := application newCommandFactory
		sendAndWait: 'llCommand registry includesId: ', id printString.
	self assert: inRegistry.
	obj := nil.
	obj2 := nil.
	5 timesRepeat: [ Smalltalk garbageCollect ].
	inRegistry := application newCommandFactory
		sendAndWait: 'llCommand registry includesId: ', id printString.
	self deny: inRegistry.

]
