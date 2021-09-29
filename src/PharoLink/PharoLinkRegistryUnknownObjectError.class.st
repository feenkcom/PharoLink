Class {
	#name : 'PharoLinkRegistryUnknownObjectError',
	#superclass : 'PharoLinkRegistryError',
	#instVars : [
		'objId'
	],
	#category : 'PharoLink-Registry'
}

{ #category : 'signalling' }
PharoLinkRegistryUnknownObjectError class >> signalId: objId [

	^ self new 
		objId: objId;
		messageText: ('Attempt to resolve unknown id: {1}' format:
			{ objId. });
		signal.
]

{ #category : 'accessing' }
PharoLinkRegistryUnknownObjectError >> objId [
	^ objId
]

{ #category : 'accessing' }
PharoLinkRegistryUnknownObjectError >> objId: anObject [
	objId := anObject
]
