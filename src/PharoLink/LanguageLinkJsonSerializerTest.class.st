Class {
	#name : 'LanguageLinkJsonSerializerTest',
	#superclass : 'TestCase',
	#instVars : [
		'serializer'
	],
	#category : 'PharoLink-Platform'
}

{ #category : 'testing' }
LanguageLinkJsonSerializerTest class >> isAbstract [
	^ self == LanguageLinkJsonSerializerTest
]

{ #category : 'asserting' }
LanguageLinkJsonSerializerTest >> assertDeserialize: aString equals: anObject [
	self assert: (serializer deserialize: aString) equals: anObject
]

{ #category : 'asserting' }
LanguageLinkJsonSerializerTest >> assertSerialize: anObject equals: aString [
	self assert: (serializer serialize: anObject) equals: aString
]

{ #category : 'running' }
LanguageLinkJsonSerializerTest >> jsonSerializerClass [
	self subclassResponsibility
]

{ #category : 'running' }
LanguageLinkJsonSerializerTest >> setUp [
	super setUp.
	serializer := self jsonSerializerClass new
]

{ #category : 'tests' }
LanguageLinkJsonSerializerTest >> testDeserializeArray [
	self assertDeserialize: '[33,"foo"]' equals: #(33 'foo')
]

{ #category : 'tests' }
LanguageLinkJsonSerializerTest >> testDeserializeNestedArrays [
	self assertDeserialize: '[33,["foo","bar"]]' equals: #(33 #('foo' 'bar'))
]

{ #category : 'tests' }
LanguageLinkJsonSerializerTest >> testDeserializeNil [
	self assertDeserialize: 'null' equals: nil
]

{ #category : 'tests' }
LanguageLinkJsonSerializerTest >> testSerializeArray [
	self assertSerialize: #(33 'foo') equals: '[33,"foo"]'
]

{ #category : 'tests' }
LanguageLinkJsonSerializerTest >> testSerializeNestedArrays [
	self assertSerialize: #(33 #('foo' 'bar')) equals: '[33,["foo","bar"]]'
]

{ #category : 'tests' }
LanguageLinkJsonSerializerTest >> testSerializeNil [
	self assertSerialize: nil equals: 'null'
]
