Class {
	#name : #PharoLinkJSONWriter,
	#superclass : #NeoJSONWriter,
	#instVars : [
		'registry'
	],
	#category : #'PharoLink-Serializer'
}

{ #category : #accessing }
PharoLinkJSONWriter >> registry [ 

	^ registry ifNil: [ registry := PharoLinkRegistry default ]
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
