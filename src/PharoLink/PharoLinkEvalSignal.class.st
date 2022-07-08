Class {
	#name : #PharoLinkEvalSignal,
	#superclass : #PharoLinkSignal,
	#instVars : [
		'command'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #'instance creation' }
PharoLinkEvalSignal class >> emitCommand: aPharoLinkEvalCommand [

	^ self new
		command: aPharoLinkEvalCommand;
		emit.
]

{ #category : #accessing }
PharoLinkEvalSignal >> command [
	^ command
]

{ #category : #accessing }
PharoLinkEvalSignal >> command: anObject [
	command := anObject
]

{ #category : #private }
PharoLinkEvalSignal >> firstLineOf: aString [

	aString linesDo: [ :line | ^line ]
]

{ #category : #accessing }
PharoLinkEvalSignal >> gtViewCommandBindingsFor: aView [
	<gtView>
	
	self command ifNil: [
		^ aView empty ].
	
	^ aView forward
		title: 'Command Bindings';
		object: [ self command ];
		view: #gtViewCommandBindingsFor:
]

{ #category : #accessing }
PharoLinkEvalSignal >> gtViewCommandStringFor: aView [
	<gtView>
	
	self command ifNil: [
		^ aView empty ].
	
	^ aView forward
		title: 'Command String';
		object: [ self command ];
		view: #gtViewCommandStringFor:
]

{ #category : #printing }
PharoLinkEvalSignal >> printOn: stream [ 

	stream 
		nextPutAll: self timestamp asString;
		space;
		nextPutAll: self class name;
		space.
	command ifNil: [ ^stream << '<no command>' ].
	command blockString ifNil: [ ^stream << '<no source>' ].
	
	stream << command blockString.
]

{ #category : #printing }
PharoLinkEvalSignal >> printOneLineContentsOn: stream [ 

	command ifNil: [ ^stream << '<no command>' ].
	command blockString ifNil: [ ^stream << '<no source>' ].
	
	stream
		<< (self firstLineOf: command blockString);
		<< '...'
]
