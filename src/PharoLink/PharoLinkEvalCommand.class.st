Class {
	#name : 'PharoLinkEvalCommand',
	#superclass : 'Object',
	#instVars : [
		'blockString',
		'bindings',
		'id',
		'responsePort',
		'responseHost',
		'registry'
	],
	#category : 'PharoLink-Server'
}

{ #category : 'as yet unclassified' }
PharoLinkEvalCommand class >> source: aString bindings: aDictionary id: anIdString [

	^ self new
		blockString: aString;
		bindings: aDictionary;
		id: anIdString;
		yourself.
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> bindings [
	^ bindings
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> bindings: anObject [
	bindings := anObject
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> blockString [
	^ blockString
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> blockString: anObject [
	blockString := anObject
]

{ #category : 'running' }
PharoLinkEvalCommand >> execute: globalsDictionary [
	| receiver |

	PharoLinkEvalSignal emitCommand: self.
	self bindings at: #llCommand put: self.
	globalsDictionary associationsDo: [ :assoc |
		self bindings at: assoc key put: assoc value ].
	receiver := self bindings at: 'self' ifAbsent: [ nil ].
	[ self class compiler
		source: self blockString;
		bindings: self bindings;
		receiver: receiver;
		evaluate ]
			on: Error 
			do: [ :ex | self notifyError: ex ]
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> gtViewedObjectClass [
	"Answer the class used to server gtViews.
	WARNING: This method is part of the GToolkit-RemotePharo package.  It shouldn't be confused with the extension method defined in TBD"
	| env |

	env := self class environment.
	(env includesKey: #GtViewedObject) ifTrue: [ ^ env at: #GtViewedObject ].
	(env includesKey: #GtRemotePhlowViewedObject) ifTrue: [ ^ env at: #GtRemotePhlowViewedObject ].
	self error: 'Unable to find Gt view server'.
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> id [
	^ id
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> id: anObject [
	id := anObject
]

{ #category : 'initialization' }
PharoLinkEvalCommand >> initialize [

	super initialize.
	responseHost := 'localhost'.
]

{ #category : 'private' }
PharoLinkEvalCommand >> notify: anObject command: commandIdString observer: observerIdString [
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'CALLBACK';
		at: 'commandId' put: commandIdString;
		at: 'observerId' put: observerIdString;
		at: 'value' put: (PharoLinkServerSerializer serialize: anObject registry: registry).
	^ (PharoLinkServerSerializer deserialize: (self sendResponse: data) contents registry: registry) at: #value.
]

{ #category : 'private' }
PharoLinkEvalCommand >> notify: anObject id: anIdString [ 
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'EVAL';
		at: 'id' put: anIdString;
		at: 'value' put: (PharoLinkServerSerializer serialize: anObject registry: registry).
	^ self sendResponse: data.
]

{ #category : 'private' }
PharoLinkEvalCommand >> notifyError: error [
	"Notify the client of the error encountered during evaluation"
	| data |

	"NetworkErrors typically mean that the client has gone away, just log and move on"
	(error isKindOf: NetworkError) ifTrue: 
		[ PharoLinkNetworkErrorSignal emitCommand: self error: error.
		^ self ].

	data := Dictionary new.
	data 	
		at: 'type' put: 'ERR';
		at: 'errMsg' put: error printString;
		at: 'commandId' put: self id;
		at: 'trace' put: self stackString.
	^ self sendResponse: data.
]

{ #category : 'private' }
PharoLinkEvalCommand >> notifyImmediate: anObject id: anIdString [ 
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'EVAL';
		at: 'id' put: anIdString;
		at: 'value' put: (NeoJSONWriter toString: anObject).
	^ self sendResponse: data.
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> registry [
	^ registry
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> registry: anObject [
	registry := anObject
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> responseHost [
	^ responseHost
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> responseHost: anObject [
	responseHost := anObject
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> responsePort [
	^ responsePort
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> responsePort: anObject [
	responsePort := anObject
]

{ #category : 'private' }
PharoLinkEvalCommand >> sendResponse: data [
	| url entity response |

	url := ZnUrl new 
		scheme: 'http';
		host: responseHost;
		port: responsePort;
		addPathSegment: (data at: 'type').

	data at: '__sync' put: UUIDGenerator next.
	entity := ZnEntity json: (NeoJSONWriter toString: data).

	response := ZnClient new
		beOneShot;
		url: url;
		entity: entity;
		logLevel: 0;
		post;
		response.

	response status = 200 ifFalse: 
		[ PharoLinkBadResponseSignal emitRequest: data response: response ].

	^ response
]

{ #category : 'accessing' }
PharoLinkEvalCommand >> stackString [

	^ String streamContents: [ :stream |
		thisContext stack do: [ :stackItem |
			stream print: stackItem; cr ] ]
]
