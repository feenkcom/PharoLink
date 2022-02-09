"
PharoLinkAnswerByValue is a per-command flag that tells the PharoLinkServer how to encode the response.

Primitives (strings, numbers, booleans, nil) are always returned by value.

For other objects, the values are:

- #never - Collections (Dictionaries and Arrays) and other objects are always returned by proxy.
- #value - Collections are returned by value.  Entries will be returned by proxy if required.
- #valueOnly - Collections contain only primitives and other collections.  If this isn't possible, an error is raised.
- #serialized - Objects that have a LeJsonV4 representation will be serialised.

Futures: Allowing values that can be JSON encoded in the standard Gt format (currently {{gtClass:LeJsonV4}}) to be returned by value.
"
Class {
	#name : #PharoLinkAnswerByValue,
	#superclass : #DynamicVariable,
	#category : #'PharoLink-Registry'
}

{ #category : #api }
PharoLinkAnswerByValue class >> during: aBlock [
	"Evaluate the supplied block with the receiver's default value"

	^ self
		value: (NewValueHolder value: #never)
		during: aBlock
]

{ #category : #accessing }
PharoLinkAnswerByValue class >> flag [
	"Answer the receiver's value (one of: #never, #value, #serialized, #valueOnly), allowing for the case where the value hasn't been set"

	^ self value 
		ifNil: [ #never ]
		ifNotNil: [ :valueHolder | valueHolder value ]
]

{ #category : #api }
PharoLinkAnswerByValue class >> setByProxy [
	"Set the flag to answer by proxy"

	self value ifNil: [ ^ self ].
	self value value: #never
]

{ #category : #api }
PharoLinkAnswerByValue class >> setBySerialized [
	"Set the flag to answer by value, replacing entries with proxies if required"

	self value ifNil: [ ^ self ].
	self value value: #serialized.
]

{ #category : #api }
PharoLinkAnswerByValue class >> setByValue [
	"Set the flag to answer by value, replacing entries with proxies if required"

	self value ifNil: [ ^ self ].
	self value value: #value
]

{ #category : #api }
PharoLinkAnswerByValue class >> setByValueOnly [
	"Set the flag to answer by value only"

	self value ifNil: [ ^ self ].
	self value value: #valueOnly
]
