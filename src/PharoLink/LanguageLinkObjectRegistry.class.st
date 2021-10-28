Class {
	#name : #LanguageLinkObjectRegistry,
	#superclass : #Object,
	#instVars : [
		'objectTable',
		'semaphore',
		'idTable'
	],
	#category : 'PharoLink-Execution'
}

{ #category : #testing }
LanguageLinkObjectRegistry >> hasId: anId [
	^ semaphore critical: [ idTable includesKey: anId ]
]

{ #category : #accessing }
LanguageLinkObjectRegistry >> idTable [
	^ idTable
]

{ #category : #'initialize-release' }
LanguageLinkObjectRegistry >> initialize [
	super initialize.
	idTable := WeakValueDictionary new.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #api }
LanguageLinkObjectRegistry >> registerObject: anObject [
	semaphore critical: [ 
		idTable at: anObject id put: anObject ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> resolve: anId [
	^ semaphore critical: [ idTable at: anId ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> resolve: anId ifAbsent: aBlock [
	| obj |
	obj := semaphore critical: [ idTable at: anId ifAbsent: [ nil ] ].
	^ obj ifNil: aBlock.
	
]

{ #category : #api }
LanguageLinkObjectRegistry >> unregisterId: anId [
	semaphore critical: [ idTable removeKey: anId ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> unregisterObject: anObject [
	semaphore critical: [ idTable removeKey: anObject id ]
]
