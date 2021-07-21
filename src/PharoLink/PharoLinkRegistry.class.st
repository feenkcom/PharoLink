Class {
	#name : 'PharoLinkRegistry',
	#superclass : 'Object',
	#instVars : [
		'idToObjMap',
		'objToIdMap'
	],
	#classVars : [
		'Default'
	],
	#category : 'PharoLink-Registry'
}

{ #category : 'accessing' }
PharoLinkRegistry class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'testing' }
PharoLinkRegistry class >> isPrimitive: anObject [
	"Answer a boolean indicating whether the supplied object is considered a primitive,
	i.e. one of Integer, String, Boolean, Array"

	^ anObject isInteger or:
		[ anObject isString or: 
		[ anObject isBoolean or:
		[ anObject isArray ] ] ]
]

{ #category : 'registry' }
PharoLinkRegistry >> clean: anObjId [

	^ self deregister: anObjId
]

{ #category : 'private' }
PharoLinkRegistry >> createNewObjId [
	"Answer a new object id"

	^ UUIDGenerator next asString
]

{ #category : 'registry' }
PharoLinkRegistry >> deregister: anObjId [
	"Remove the supplied id"
	| object |

	object := idToObjMap at: anObjId.
	idToObjMap removeKey: anObjId.
	objToIdMap removeKey: object.
	^ nil.
]

{ #category : 'testing' }
PharoLinkRegistry >> includesId: anId [
	"Answer a boolean indicating if the supplied id is registered"

	^ idToObjMap includesKey: anId
]

{ #category : 'initialization' }
PharoLinkRegistry >> initialize [ 

	super initialize.
	idToObjMap := Dictionary new.
	objToIdMap := Dictionary new.
]

{ #category : 'testing' }
PharoLinkRegistry >> isPrimitive: anObject [
	"Answer a boolean indicating whether the supplied object is considered a primitive,
	i.e. one of Integer, String, Boolean, Array"

	^ self class isPrimitive: anObject
]

{ #category : 'private' }
PharoLinkRegistry >> primRegister: anObject withId: newObjId [
	"Register the supplied object with the supplied id.
	anObject must not already be registered, newObjId must be unique"

	idToObjMap at: newObjId put: anObject.
	objToIdMap at: anObject put: newObjId.
	^ newObjId
]

{ #category : 'registry' }
PharoLinkRegistry >> register: anObject [
	"Add anObject to the receiver.
	If the object is already registered, answer its id."

	(anObject isNil or: [ self isPrimitive: anObject ])
		ifTrue: [ ^nil ].

	(objToIdMap includesKey: anObject) ifTrue: 
		[ ^objToIdMap at: anObject ].

	^ self primRegister: anObject withId: self createNewObjId.
]

{ #category : 'registry' }
PharoLinkRegistry >> register: anObject withId: newObjId [
	"Register the supplied object with the supplied id.
	Check that the object is a valid type and isn't registered with a different id"

	(anObject isNil or: [ self isPrimitive: anObject ]) ifTrue: 
		[ PharoLinkRegistryForbiddenObjectError signal ].

	(objToIdMap includesKey: anObject) ifTrue: 
		[ (objToIdMap at: anObject) = newObjId ifTrue: 
			[ ^ newObjId ]
		ifFalse:
			[ PharoLinkRegistryDifferentIdError signalId: newObjId object: anObject ] ]
	ifFalse:
		[ self primRegister: anObject withId: newObjId ].
	^ newObjId
]

{ #category : 'resolving' }
PharoLinkRegistry >> resolve: objId [
	"Answer the object with the supplied id"

	^ idToObjMap 
		at: objId
		ifAbsent: [ PharoLinkRegistryUnknownObjectError signalId: objId ]
]
