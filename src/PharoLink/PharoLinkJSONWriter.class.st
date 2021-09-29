"
Write the JSON textual representation of an object to the receiver's stream for PharoLink.

Primitives, which are Integers, Strings and Arrays, are returned immediately.  All other objects are added to a registry and returned as a dictionary with the object's class and registry id, allowing a proxy object to be generated in the client.


!!Internal Representation and Key Implementation Points.

!!!Instance Variables

	registry:		<PharoLinkRegistry> the registry of non-primitive objects.

"
Class {
	#name : 'PharoLinkJSONWriter',
	#superclass : 'NeoJSONWriter',
	#instVars : [
		'registry'
	],
	#category : 'PharoLink-Server'
}

{ #category : 'convenience' }
PharoLinkJSONWriter class >> toString: object registry: registry [

	^ String streamContents: [ :stream |
			(self on: stream) 
				registry: registry;
				nextPut: object ]
]

{ #category : 'convenience' }
PharoLinkJSONWriter class >> toStringPretty: object registry: registry [ 

	^ String streamContents: [ :stream |
			(self on: stream)
				prettyPrint: true; 
				registry: registry;
				nextPut: object ]
]

{ #category : 'accessing' }
PharoLinkJSONWriter >> registry [ 

	^ registry "ifNil: [ registry := PharoLinkRegistry default ]"
]

{ #category : 'accessing' }
PharoLinkJSONWriter >> registry: anObject [
	registry := anObject
]

{ #category : 'writing' }
PharoLinkJSONWriter >> writeList: collection [ 

	^collection isArray
		ifTrue: [ super writeList: collection ]
		ifFalse: [ self writeObject: collection ]
]

{ #category : 'writing' }
PharoLinkJSONWriter >> writeMap: keyValueCollection [

	^ (keyValueCollection at: #'__pharolinkImmediate' ifAbsent: [ false ])
		ifTrue: [ super writeMap: keyValueCollection ]
		ifFalse: [ self writeObject: keyValueCollection ]
]

{ #category : 'writing' }
PharoLinkJSONWriter >> writeObject: anObject [

	^ 	self writeMapStreamingDo: [ :jsonMapWriter |
			jsonMapWriter 
				writeKey: '__class__' value: anObject class name;
				writeKey: '__registryid__' value: (self registry register: anObject) ]
]
