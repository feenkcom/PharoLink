Class {
	#name : #LanguageLinkProxyObject,
	#superclass : #Object,
	#traits : 'TGtPharoLinkPlayground',
	#classTraits : 'TGtPharoLinkPlayground classTrait',
	#instVars : [
		'application',
		'remoteClass',
		'name'
	],
	#category : #'PharoLink-Core'
}

{ #category : #'instance creation' }
LanguageLinkProxyObject class >> remoteClass: remoteClassName name: registryId 	application: aLLApplication [

	^ self new
		remoteClass: remoteClassName;
		name: registryId;
		application: aLLApplication
]

{ #category : #comparing }
LanguageLinkProxyObject >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ remoteClass = anObject remoteClass
		and: [ application = anObject application
				and: [ name = anObject name ] ]
]

{ #category : #accessing }
LanguageLinkProxyObject >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkProxyObject >> application: anObject [
	application := anObject
]

{ #category : #comparing }
LanguageLinkProxyObject >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ remoteClass hash bitXor: (application hash bitXor: name hash)
]

{ #category : #accessing }
LanguageLinkProxyObject >> id [ 

	^ name
]

{ #category : #accessing }
LanguageLinkProxyObject >> name [
	^ name
]

{ #category : #accessing }
LanguageLinkProxyObject >> name: anObject [
	name := anObject
]

{ #category : #serialization }
LanguageLinkProxyObject >> neoJsonOn: aWriter [

	{ '__class__' -> remoteClass.
	'__registryid__' -> name. } asDictionary
		neoJsonOn: aWriter
]

{ #category : #'instance creation' }
LanguageLinkProxyObject >> newCommandFactory [
	| cf |

	cf := self application newCommandFactory.
	self addPlaygroundBindingsTo: cf.
	^ cf
]

{ #category : #accessing }
LanguageLinkProxyObject >> pharoLinkFormattedCode [ 

	^ 'llCommand registry resolve: ', name printString
]

{ #category : #printing }
LanguageLinkProxyObject >> printOn: str [
	str 
		<< (remoteClass asString first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		<< remoteClass asString;
		<< ' (Proxy)'
]

{ #category : #accessing }
LanguageLinkProxyObject >> remoteClass [
	^ remoteClass
]

{ #category : #accessing }
LanguageLinkProxyObject >> remoteClass: anObject [
	remoteClass := anObject
]

{ #category : #accessing }
LanguageLinkProxyObject >> settings [ 

	^ application settings
]
