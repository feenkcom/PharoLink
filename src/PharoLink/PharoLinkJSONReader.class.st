Class {
	#name : #PharoLinkJSONReader,
	#superclass : #NeoJSONReader,
	#instVars : [
		'registry'
	],
	#category : 'PharoLink-Server'
}

{ #category : #'instance creation' }
PharoLinkJSONReader class >> fromString: aString registry: aPharoLinkRegistry [

	^ (self new 
		registry: aPharoLinkRegistry;
		on: aString readStream)
			next
]

{ #category : #parsing }
PharoLinkJSONReader >> parseMap [ 
	| map |

	map := super parseMap.
	(map size = 2 and: [ map includesKey: #'__class__' ]) ifFalse:
		[ ^ map ].
 
	map 
		at: #'__registryid__'
		ifPresent: [ :id | ^ registry resolve: id ].

	map
		at: #'__serialized__'
		ifPresent: [ :string | | anObject |
			anObject := LeJsonV4 uniqueInstance deserialize: string readStream.
			self assert: anObject class name = (map at: #'__class__').
			^ anObject ].

	self error: 'Unknown object representation'.
]

{ #category : #accessing }
PharoLinkJSONReader >> registry [
	^ registry
]

{ #category : #accessing }
PharoLinkJSONReader >> registry: anObject [
	registry := anObject
]
