Class {
	#name : #LanguageLinkMessageTest,
	#superclass : #TestCase,
	#category : #'PharoLink-Tests'
}

{ #category : #tests }
LanguageLinkMessageTest >> stubMessage [
	^ LanguageLinkStubMessage new
		ivar1: #foo;
		ivar2: #(3 #bar);
		yourself
]

{ #category : #tests }
LanguageLinkMessageTest >> testDecodeAnswer [
	| msg dict ans |
	msg := self stubMessage.
	dict := {
		(#type -> #STUB).
		(#ivar1 -> #foo).
		(#ivar2f -> 3).
		(#ivar2r -> #(#zork)).
		(#__sync -> msg syncId)} asDictionary.
	ans := msg createAnswer decode: dict.
	self assert: ans ivar1 equals: #foo.
	self assert: ans ivar2 equals: #(3 #zork).
]

{ #category : #tests }
LanguageLinkMessageTest >> testDecodeBaseMessage [
	self 
		assert: (LanguageLinkSyncMessage new createAnswer decode: { #type -> #MSG } asDictionary) class
		equals: LanguageLinkAnswer
]

{ #category : #tests }
LanguageLinkMessageTest >> testEncodeBaseMessage [
	self 
		assert: LanguageLinkMessage new encode 
		equals: { #type -> #MSG } asDictionary
]

{ #category : #tests }
LanguageLinkMessageTest >> testEncodeMessage [
	| msg dict |
	msg := self stubMessage.
	dict := {
		(#type -> #STUB).
		(#ivar1 -> #foo).
		(#ivar2f -> 3).
		(#ivar2r -> #(#bar)).
		(#__sync -> msg syncId)} asDictionary.
	self assert: msg encode equals: dict
]

{ #category : #tests }
LanguageLinkMessageTest >> testNoDuplicatedTypes [
	| messageClasses |
	messageClasses := LanguageLinkAbstractMessage allSubclasses.
	self assert: (messageClasses collect: #type) asSet size equals: messageClasses size
]
