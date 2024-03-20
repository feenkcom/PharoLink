Class {
	#name : #LanguageLinkObjectRegistry,
	#superclass : #Object,
	#instVars : [
		'idTable',
		'mutex'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #testing }
LanguageLinkObjectRegistry >> hasId: anId [
	^ mutex critical: [ idTable includesKey: anId ]
]

{ #category : #accessing }
LanguageLinkObjectRegistry >> idTable [
	^ idTable
]

{ #category : #'initialize-release' }
LanguageLinkObjectRegistry >> initialize [
	super initialize.
	idTable := WeakValueDictionary new.
	mutex := Mutex new
]

{ #category : #api }
LanguageLinkObjectRegistry >> registerObject: anObject [
	mutex critical: [ 
		idTable at: anObject id put: anObject ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> resolve: anId [
	^ mutex critical: [ idTable at: anId ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> resolve: anId ifAbsent: aBlock [
	^ mutex critical: [ idTable at: anId ifAbsent: aBlock ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> resolveEncodedObject: rawObj [

	self assert: rawObj size = 2.
	self assert: (rawObj includesKey: #__class__).

	rawObj
		at: #__registryid__
		ifPresent: [ :anId | ^ mutex critical: [ idTable at: anId ] ].

	rawObj
		at: #__serialized__
		ifPresent: [ :string | | anObject |
			anObject := LeJsonV4 uniqueInstance deserialize: string.
			self assert: anObject class name = (rawObj at: #'__class__').
			^ anObject ].

	self error: 'Unknown object representation'.
]

{ #category : #api }
LanguageLinkObjectRegistry >> resolveEncodedObject: rawObj ifAbsent: absentBlock [
	self assert: rawObj size = 2.
	self assert: (rawObj includesKey: #__class__).

	rawObj
		at: #__registryid__
		ifPresent: [ :anId | ^ mutex critical: [ idTable at: anId ifAbsent: absentBlock ] ].

	rawObj
		at: #__serialized__
		ifPresent: [ :string | 
			| anObject |
			anObject := LeJsonV4 uniqueInstance deserialize: string readStream.
			self assert: anObject class name = (rawObj at: #__class__).
			^ anObject ].

	self error: 'Unknown object representation'
]

{ #category : #api }
LanguageLinkObjectRegistry >> unregisterId: anId [
	mutex critical: [ idTable removeKey: anId ]
]

{ #category : #api }
LanguageLinkObjectRegistry >> unregisterObject: anObject [
	mutex critical: [ idTable removeKey: anObject id ]
]
