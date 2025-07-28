Class {
	#name : #PharoLinkRegistry,
	#superclass : #Object,
	#instVars : [
		'idToObjMap',
		'objToIdMap',
		'oldIds'
	],
	#classVars : [
		'Default'
	],
	#category : #'PharoLink-Registry'
}

{ #category : #accessing }
PharoLinkRegistry class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : #testing }
PharoLinkRegistry class >> isPrimitive: anObject [
	"Answer a boolean indicating whether the supplied object is considered a primitive,
	i.e. one of nil, Integer, String, Boolean
	Arrays are a json primitive, but are handled by #asPharoLinkObjectRegistry:"

	^ anObject isNil or:
		[ anObject isInteger or:
		[ anObject isString or: 
		[ anObject isBoolean or:
		[ anObject isFloat ] ] ] ]
]

{ #category : #registry }
PharoLinkRegistry >> clean: anObjId [

	^ self deregister: anObjId
]

{ #category : #private }
PharoLinkRegistry >> createNewObjId [
	"Answer a new object id"

	^ UUID new asString
]

{ #category : #registry }
PharoLinkRegistry >> deregister: anObjId [
	"Remove the supplied id"
	| object olds |

	olds := oldIds at: anObjId ifAbsentPut: [ OrderedCollection new ].
	object := idToObjMap at: anObjId ifAbsent: 
		[ olds add: DateAndTime now -> #missing.
		^ nil ].
	idToObjMap removeKey: anObjId.
	objToIdMap removeKey: object.
	olds add: DateAndTime now -> object class name.
	^ nil.
]

{ #category : #testing }
PharoLinkRegistry >> includesId: anId [
	"Answer a boolean indicating if the supplied id is registered"

	^ idToObjMap includesKey: anId
]

{ #category : #initialization }
PharoLinkRegistry >> initialize [ 

	super initialize.
	idToObjMap := Dictionary new.
	objToIdMap := Dictionary new.
	oldIds := Dictionary new.
]

{ #category : #registry }
PharoLinkRegistry >> jsonObjectFor: anObject [
	"Answer the JSON proxy representation for anObject"

	^ {
			'__class__' -> anObject class name.
			'__registryid__' -> (self register: anObject).
		} asDictionary
]

{ #category : #registry }
PharoLinkRegistry >> jsonSerializationFor: anObject [
	"Answer the JSON serialisation representation for anObject"

	^ {
			'__class__' -> anObject class name.
			'__serialized__' -> (LeJsonV4 uniqueInstance serialize: anObject).
		} asDictionary
]

{ #category : #private }
PharoLinkRegistry >> primRegister: anObject withId: newObjId [
	"Register the supplied object with the supplied id.
	anObject must not already be registered, newObjId must be unique"

	idToObjMap at: newObjId put: anObject.
	objToIdMap at: anObject put: newObjId.
	^ newObjId
]

{ #category : #registry }
PharoLinkRegistry >> register: anObject [
	"Add anObject to the receiver.
	If the object is already registered, answer its id."

	anObject isPharoLinkPrimitive ifTrue: 
		[ PharoLinkRegistryForbiddenObjectError signal ].

	(objToIdMap includesKey: anObject) ifTrue: 
		[ ^objToIdMap at: anObject ].

	^ self primRegister: anObject withId: self createNewObjId.
]

{ #category : #registry }
PharoLinkRegistry >> register: anObject withId: newObjId [
	"Register the supplied object with the supplied id.
	Check that the object is a valid type and isn't registered with a different id"

	anObject isPharoLinkPrimitive ifTrue: 
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

{ #category : #resolving }
PharoLinkRegistry >> resolve: objId [
	"Answer the object with the supplied id"

	^ idToObjMap at: objId ifAbsent: 
		[ PharoLinkRegistryUnknownIdSignal new
			unknownId: objId;
			isOld: (oldIds includes: objId).
		PharoLinkRegistryUnknownObjectError signalId: objId ]
]
