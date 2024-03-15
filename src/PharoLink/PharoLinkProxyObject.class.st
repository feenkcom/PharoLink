Class {
	#name : #PharoLinkProxyObject,
	#superclass : #LanguageLinkProxyObject,
	#category : #'PharoLink-Pharo-Platform'
}

{ #category : #accessing }
PharoLinkProxyObject class >> leProxyTypeForPlaygroundPage [
	^ PharoLinkProxyObject
]

{ #category : #'instance creation' }
PharoLinkProxyObject class >> remoteClass: remoteClassName name: registryId 	application: aLLApplication [
	| proxyClass |

	proxyClass := self allSubclasses
		detect: [ :each | each remoteClassName = remoteClassName ]
		ifNone: 
			[ (remoteClassName endsWith: ' class')
				ifTrue: [ PlpoClass ]
				ifFalse: [ self ] ].

	^ proxyClass new
		initalizeWithRemoteClass: remoteClassName
		name: registryId
		application: aLLApplication
]

{ #category : #accessing }
PharoLinkProxyObject class >> remoteClassName [

	^ self subclassResponsibility 
]

{ #category : #converting }
PharoLinkProxyObject >> asGtBareProxyObject [

	^ GtPlBareProxy forProxyObject: self
]

{ #category : #converting }
PharoLinkProxyObject >> asGtProxyObject [ 

	^ self
]

{ #category : #accessing }
PharoLinkProxyObject >> canBePharoLinkPrimitive [
	"Answer a boolean indicating whether the receiver can be a PharoLink primitive object,
	i.e. it can be completely encoded in JSON format."

	^ true
]

{ #category : #accessing }
PharoLinkProxyObject >> getSerialized [
	"Answer the receiver as a local object, i.e. copy it from the server.
	This only works for objects that support LeJsonV4 serialization."

	^ self newCommandFactory 
		setBySerialized;
		<< 'self';
		sendAndWait.
]

{ #category : #accessing }
PharoLinkProxyObject >> getText [
	^ self newCommandFactory
		setByValue;
		<< 'self getText';
		sendAndWait
]

{ #category : #accessing }
PharoLinkProxyObject >> getValue [
	"Answer the receiver as a local object, i.e. copy it from the server.
	This only works for objects that support answer by value, e.g. Arrays and Dictionaries.  Other objects will answer the proxy."

	^ self newCommandFactory 
		setByValue;
		<< 'self';
		sendAndWait.
]

{ #category : #accessing }
PharoLinkProxyObject >> languageLinkSerializable [

	^ {
		'__class__' -> remoteClass.
		'__registryid__' -> name.
	} asDictionary
]
