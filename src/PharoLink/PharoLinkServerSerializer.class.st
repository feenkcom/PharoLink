"
PharoLinkServerSerializer is responsible for encoding and decoding objects in the PharoLinkServer.

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	registry:		<Object>


    Implementation Points
"
Class {
	#name : 'PharoLinkServerSerializer',
	#superclass : 'Object',
	#instVars : [
		'registry'
	],
	#category : 'PharoLink-Server'
}

{ #category : 'serialization' }
PharoLinkServerSerializer class >> deserialize: anObject registry: aRegistry [

	^ self new 
		registry: aRegistry;
		deserialize: anObject
]

{ #category : 'serialization' }
PharoLinkServerSerializer class >> serialize: anObject registry: aRegistry [

	^ self new 
		registry: aRegistry;
		serialize: anObject
]

{ #category : 'private' }
PharoLinkServerSerializer >> deserialize: aString [

	^ PharoLinkJSONReader fromString: aString registry: registry
]

{ #category : 'accessing' }
PharoLinkServerSerializer >> registry [
	^ registry
]

{ #category : 'accessing' }
PharoLinkServerSerializer >> registry: anObject [
	registry := anObject
]

{ #category : 'private' }
PharoLinkServerSerializer >> serialize: anObject [

	^ PharoLinkJSONWriter toString: anObject registry: registry
]
