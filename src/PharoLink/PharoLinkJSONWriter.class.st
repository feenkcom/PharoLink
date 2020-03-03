Class {
	#name : #PharoLinkJSONWriter,
	#superclass : #NeoJSONWriter,
	#instVars : [
		'registry'
	],
	#category : #'PharoLink-Server'
}

{ #category : #convenience }
PharoLinkJSONWriter class >> toString: object registry: registry [

	^ String streamContents: [ :stream |
			(self on: stream) 
				registry: registry;
				nextPut: object ]
]

{ #category : #convenience }
PharoLinkJSONWriter class >> toStringPretty: object registry: registry [ 

	^ String streamContents: [ :stream |
			(self on: stream)
				prettyPrint: true; 
				registry: registry;
				nextPut: object ]
]

{ #category : #accessing }
PharoLinkJSONWriter >> registry [ 

	^ registry "ifNil: [ registry := PharoLinkRegistry default ]"
]

{ #category : #accessing }
PharoLinkJSONWriter >> registry: anObject [
	registry := anObject
]

{ #category : #writing }
PharoLinkJSONWriter >> writeObject: anObject [

	^ 	self writeMapStreamingDo: [ :jsonMapWriter |
			jsonMapWriter 
				writeKey: '__class__' value: anObject class name;
				writeKey: '__registryid__' value: (self registry register: anObject) ]
]
