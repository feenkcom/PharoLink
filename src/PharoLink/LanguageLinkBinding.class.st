Class {
	#name : 'LanguageLinkBinding',
	#superclass : 'Object',
	#instVars : [
		'object',
		'key'
	],
	#category : 'PharoLink-Execution'
}

{ #category : 'instance creation' }
LanguageLinkBinding class >> key: aKey wrap: anObject [
	^ self new
		key: aKey;
		object: anObject;
		yourself
]

{ #category : 'instance creation' }
LanguageLinkBinding class >> wrap: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : 'initialization' }
LanguageLinkBinding >> initialize [
	super initialize.
	key := 'll' , UUID new asString36
]

{ #category : 'testing' }
LanguageLinkBinding >> isLanguageLinkValue [
	^ true
]

{ #category : 'accessing' }
LanguageLinkBinding >> key [
	^ key
]

{ #category : 'accessing' }
LanguageLinkBinding >> key: anObject [
	key := anObject
]

{ #category : 'accessing' }
LanguageLinkBinding >> object [
	^ object
]

{ #category : 'accessing' }
LanguageLinkBinding >> object: anObject [
	object := anObject
]

{ #category : 'printing' }
LanguageLinkBinding >> printOn: aStream [

	super printOn: aStream.
	key ifNotNil:
		[ aStream
			<< '(';
			<< key;
			<< ')' ]
]
