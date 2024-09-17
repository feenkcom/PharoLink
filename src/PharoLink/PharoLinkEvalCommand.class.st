Class {
	#name : #PharoLinkEvalCommand,
	#superclass : #Object,
	#instVars : [
		'blockString',
		'bindings',
		'id',
		'connection',
		'registry'
	],
	#category : #'PharoLink-Server'
}

{ #category : #'instance creation' }
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

{ #category : #accessing }
PharoLinkEvalCommand >> connection [
	<return: #PharoLinkServerConnection>

	^ connection
]

{ #category : #accessing }
PharoLinkEvalCommand >> connection: aPharoLinkServerConnection [

	connection := aPharoLinkServerConnection
]

{ #category : #running }
PharoLinkEvalCommand >> execute: globalsDictionary [
	| receiver |

	PharoLinkEvalSignal emitCommand: self.
	self bindings at: #llCommand put: self.
	globalsDictionary associationsDo: [ :assoc |
		self bindings at: assoc key put: assoc value ].
	receiver := self bindings at: #self ifAbsent: [ nil ].
	[ PharoLinkAnswerByValue during: [ self class compiler
		source: self blockString;
		bindings: self bindings;
		receiver: receiver;
		evaluate ] ]
			on: Error 
			do: [ :ex | self notifyError: ex ]
]

{ #category : #'gt - extensions' }
PharoLinkEvalCommand >> gtViewCommandBindingsFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Bindings';
		object: [ self bindings ];
		view: #gtItemsFor:
]

{ #category : #'gt - extensions' }
PharoLinkEvalCommand >> gtViewCommandStringFor: aView [
	<gtView>
	
	^ aView textEditor
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new
				   isForWorkspace: true;
				   yourself);
		title: 'Block string' translated;
		text: [ self blockString ];
		priority: 15
]

{ #category : #accessing }
PharoLinkEvalCommand >> gtViewedObjectClass [
	"Answer the class used to server gtViews.
	WARNING: This method is part of the GToolkit-RemotePharo package.  It shouldn't be confused with the extension method defined in TBD"
	| env |

	env := self class environment.
	(env includesKey: #GtViewedObject) ifTrue: [ ^ env at: #GtViewedObject ].
	(env includesKey: #GtRemotePhlowViewedObject) ifTrue: [ ^ env at: #GtRemotePhlowViewedObject ].
	self error: 'Unable to find Gt view server'.
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
		at: 'value' put: (PharoLinkServerSerializer serialize: anObject registry: self registry).
	^ self sendSyncResponse: data.
]

{ #category : #private }
PharoLinkEvalCommand >> notify: anObject id: anIdString [ 
	| data |

	data := Dictionary new.
	data 	
		at: 'type' put: 'EVAL';
		at: 'id' put: anIdString;
		at: 'value' put: (PharoLinkServerSerializer serialize: anObject registry: self registry).
	^ self sendAsyncResponse: data.
]

{ #category : #private }
PharoLinkEvalCommand >> notifyError: error [
	"Notify the client of the error encountered during evaluation"
	| data |

	"NetworkErrors typically mean that the client has gone away, just log and move on"
	(error isKindOf: NetworkError) ifTrue: [ 
		PharoLinkNetworkErrorSignal emitCommand: self error: error.
		^ self ].

	data := Dictionary new.
	data 	
		at: 'type' put: 'ERR';
		at: 'errMsg' put: error printString;
		at: 'commandId' put: self id;
		at: 'trace' put: self stackString.
	^ [ self sendSyncResponse: data ]
		on: ConnectionTimedOut, PharoLinkServerConnectionLost 
		do: [ :ex | | commsError |
			commsError := LanguageLinkCommunicationsSignal new
				originalException: error;
				commandId: self id;
				stackString: self stackString.
			commsError emit ].
]

{ #category : #accessing }
PharoLinkEvalCommand >> registry [

	^ connection registry
]

{ #category : #private }
PharoLinkEvalCommand >> sendAsyncResponse: data [

	^ connection sendAsyncMessage: data.

]

{ #category : #private }
PharoLinkEvalCommand >> sendSyncResponse: data [

	^ connection sendSyncMessage: data.

]

{ #category : #accessing }
PharoLinkEvalCommand >> stackArray [
	"Answer an array of strings representing the stack"

	^ thisContext stack 
		collect: [ :stackItem | 	stackItem printString ]
		as: Array
]

{ #category : #accessing }
PharoLinkEvalCommand >> stackString [

	^ String streamContents: [ :stream |
		thisContext stack do: [ :stackItem |
			stream print: stackItem; cr ] ]
]
