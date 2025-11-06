Class {
	#name : #LanguageLinkWeakFinalizerTest,
	#superclass : #TestCase,
	#instVars : [
		'weakRegistry',
		'assertCounter'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #testing }
LanguageLinkWeakFinalizerTest class >> isAbstract [
	^ self == LanguageLinkWeakFinalizerTest
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> assertCount: anInteger [
	self assert: assertCounter equals: anInteger
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> countFinalizer [
	^ LanguageLinkBlockFinalizer block: [ assertCounter := assertCounter + 1 ]
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> setUp [
	super setUp.
	weakRegistry := self weakRegistryClass new.
	assertCounter := 0
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> tearDown [
	weakRegistry destroy.
	super tearDown
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> testBlockFinalizer [
	self assertCount: 0.
	self countFinalizer finalize.
	self assertCount: 1
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> testDestroy [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	weakRegistry destroy.
	obj := nil.
	self triggerGC.
	self assertCount: 0
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> testGcMultObjects [
	| obj1 obj2 obj3 |
	obj1 := Object new.
	obj2 := Object new.
	obj3 := Object new.
	weakRegistry registerObject: obj1 finalizer: self countFinalizer.
	weakRegistry registerObject: obj2 finalizer: self countFinalizer.
	obj1 := nil.
	self triggerGC.
	self assertCount: 1.
	weakRegistry registerObject: obj3 finalizer: self countFinalizer.
	self triggerGC.
	self assertCount: 1.
	obj2 := nil.
	obj3 := nil.
	self triggerGC.
	self assertCount: 3
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> testGcObject [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	obj := nil.
	self triggerGC.
	self assertCount: 1
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> testNotGcObject [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	self triggerGC.
	self assertCount: 0
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> triggerGC [
	self subclassResponsibility
]

{ #category : #running }
LanguageLinkWeakFinalizerTest >> weakRegistryClass [
	self subclassResponsibility
]
