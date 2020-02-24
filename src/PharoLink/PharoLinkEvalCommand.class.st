Class {
	#name : #PharoLinkEvalCommand,
	#superclass : #Object,
	#instVars : [
		'blockString',
		'bindings',
		'id',
		'responsePort'
	],
	#category : #'PharoLink-Server'
}

{ #category : #'as yet unclassified' }
PharoLinkEvalCommand class >> source: aString bindings: aDictionary id: anIdString [

	^ self new
		blockString: aString;
		bindings: aDictionary;
		id: anIdString;
		yourself.
]

{ #category : #accessing }
PharoLinkEvalCommand >> bindings [
	^ bindings
]

{ #category : #accessing }
PharoLinkEvalCommand >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
PharoLinkEvalCommand >> blockString [
	^ blockString
]

{ #category : #accessing }
PharoLinkEvalCommand >> blockString: anObject [
	blockString := anObject
]

{ #category : #running }
PharoLinkEvalCommand >> execute: globalsDictionary [

	PharoLinkEvalSignal emitCommand: self.
	self bindings at: #llCommand put: self.
	[ self class compiler
		source: self blockString;
		bindings: self bindings;
		evaluate ]
			on: Error 
			do: [ :ex | self notifyError: ex ]
]

{ #category : #accessing }
PharoLinkEvalCommand >> id [
	^ id
]

{ #category : #accessing }
PharoLinkEvalCommand >> id: anObject [
	id := anObject
]

{ #category : #private }
PharoLinkEvalCommand >> notify: anObject command: commandIdString observer: observerIdString [
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'CALLBACK';
		at: 'commandId' put: commandIdString;
		at: 'observerId' put: observerIdString;
		at: 'value' put: (PharoLinkSerializer new serialize: anObject).
	^ PharoLinkSerializer new deserialize: (self sendResponse: data).
]

{ #category : #private }
PharoLinkEvalCommand >> notify: anObject id: anIdString [ 
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'EVAL';
		at: 'id' put: anIdString;
		at: 'value' put: (PharoLinkSerializer new serialize: anObject).
	^ self sendResponse: data.
]

{ #category : #private }
PharoLinkEvalCommand >> notifyError: error [
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'ERR';
		at: 'errMsg' put: error messageText;
		at: 'commandId' put: self id;
		at: 'trace' put: ''.
	^ PharoLinkSerializer new deserialize: (self sendResponse: data).
]

{ #category : #private }
PharoLinkEvalCommand >> notifyImmediate: anObject id: anIdString [ 
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'EVAL';
		at: 'id' put: anIdString;
		at: 'value' put: (NeoJSONWriter toString: anObject).
	^ self sendResponse: data.
]

{ #category : #accessing }
PharoLinkEvalCommand >> responsePort [
	^ responsePort
]

{ #category : #accessing }
PharoLinkEvalCommand >> responsePort: anObject [
	responsePort := anObject
]

{ #category : #private }
PharoLinkEvalCommand >> sendResponse: data [
	| url entity response |

	url := ZnUrl new 
		scheme: 'http';
		host: 'localhost';
		port: self responsePort;
		addPathSegment: (data at: 'type').

	data at: '__sync' put: UUIDGenerator next.
	entity := ZnEntity json: (NeoJSONWriter toString: data).

	response := ZnClient new
		beOneShot;
		url: url;
		entity: entity;
		post;
		response.

	response status = 200 ifFalse: 
		[ PharoLinkBadResponseSignal emitRequest: data response: response ].

	^ response
]
