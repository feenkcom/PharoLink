Class {
	#name : 'PharoLinkJSONReader',
	#superclass : 'NeoJSONReader',
	#instVars : [
		'registry'
	],
	#category : 'PharoLink-Server'
}

{ #category : 'instance creation' }
PharoLinkJSONReader class >> fromString: aString registry: aPharoLinkRegistry [

	^ (self new 
		registry: aPharoLinkRegistry;
		on: aString readStream)
			next
]

{ #category : 'parsing' }
PharoLinkJSONReader >> parseMap [ 
	| map |

	map := super parseMap.
	^ map size = 2 ifTrue: 
		[ map 
			at: '__registryid__'
			ifPresent: [ :id | registry resolve: id ]
			ifAbsent: [ map ] ]
	ifFalse: [ map ]
]

{ #category : 'accessing' }
PharoLinkJSONReader >> registry [
	^ registry
]

{ #category : 'accessing' }
PharoLinkJSONReader >> registry: anObject [
	registry := anObject
]
