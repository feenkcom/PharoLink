Class {
	#name : 'PharoLinkRegistryDifferentIdError',
	#superclass : 'PharoLinkRegistryError',
	#instVars : [
		'objId',
		'object'
	],
	#category : 'PharoLink-Registry'
}

{ #category : 'instance creation' }
PharoLinkRegistryDifferentIdError class >> signalId: objId object: anObject [

	^ self new 
		objId: objId;
		object: anObject;
		messageText: ('Attempt to register object: {1} with id: {2}' format:
			{ objId. anObject. });
		signal.
]

{ #category : 'accessing' }
PharoLinkRegistryDifferentIdError >> objId [
	^ objId
]

{ #category : 'accessing' }
PharoLinkRegistryDifferentIdError >> objId: anObject [
	objId := anObject
]

{ #category : 'accessing' }
PharoLinkRegistryDifferentIdError >> object [
	^ object
]

{ #category : 'accessing' }
PharoLinkRegistryDifferentIdError >> object: anObject [
	object := anObject
]
