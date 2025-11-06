Class {
	#name : #LanguageLinkCommand,
	#superclass : #Object,
	#instVars : [
		'id',
		'instructions',
		'bindings',
		'observers',
		'promise',
		'transformBlock'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #'instance creation' }
LanguageLinkCommand class >> forApplication: aLLApplication [ 

	^ self new initializeWith: aLLApplication 
]

{ #category : #accessing }
LanguageLinkCommand >> bindings [
	^ bindings
]

{ #category : #accessing }
LanguageLinkCommand >> bindings: bindingCol [
	bindings := bindingCol
]

{ #category : #accessing }
LanguageLinkCommand >> bindingsDictionary [
	^ self bindings asDictionary
]

{ #category : #accessing }
LanguageLinkCommand >> codeForRemote [
	| py3CodeStream |
	py3CodeStream := String new writeStream.
	self instructions do: [ :instr | 
			"If making a call, it should be await"
			instr class = JSGCall ifTrue:
				[ py3CodeStream << 'await ' ].
			instr writeJavaScriptOn: py3CodeStream.
			py3CodeStream 
				<< ';';
				<< String lf ].
	^ py3CodeStream contents
]

{ #category : #accessing }
LanguageLinkCommand >> getObserver: observerId [
	^ observers detect: [ :obs | obs id = observerId ]
]

{ #category : #'gt - extensions' }
LanguageLinkCommand >> gtViewBindigsFor: aView [ 
	<gtView>
	
	^ aView forward 
		title: 'Bindings';
		priority: 20;
		object: [ self bindings ];
		view: #gtItemsFor:
]

{ #category : #'gt - extensions' }
LanguageLinkCommand >> gtViewInstructionsFor: aView [ 
	<gtView>
	
	^ aView forward 
		title: 'Instructions';
		priority: 25;
		object: [ self instructions ];
		view: #gtItemsFor:
]

{ #category : #accessing }
LanguageLinkCommand >> id [
	^ id
]

{ #category : #accessing }
LanguageLinkCommand >> id: anObject [
	id := anObject
]

{ #category : #initialization }
LanguageLinkCommand >> initializeWith: aLLApplication [

	id := aLLApplication settings platform newRandomName.
	bindings := Dictionary new.
	observers := #().
	instructions := OrderedCollection new.
	transformBlock := #yourself
]

{ #category : #accessing }
LanguageLinkCommand >> instructions [
	^ instructions
]

{ #category : #accessing }
LanguageLinkCommand >> instructions: anObject [
	instructions := anObject
]

{ #category : #testing }
LanguageLinkCommand >> isValid [
	^ [ self id isString and: [ 
			(self bindings associations allSatisfy: [ :assoc | assoc key isString ]) and: [ 
				self observers allSatisfy: [ :obs | obs callback isBlock ] ] ] ] on: Error do: [ false ]
]

{ #category : #accessing }
LanguageLinkCommand >> observers [
	^ observers
]

{ #category : #accessing }
LanguageLinkCommand >> observers: anObject [
	observers := anObject
]

{ #category : #printing }
LanguageLinkCommand >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '(';
		print: id;
		<< ')'
]

{ #category : #accessing }
LanguageLinkCommand >> promise [
	^ promise
]

{ #category : #accessing }
LanguageLinkCommand >> promise: anObject [
	promise := anObject
]

{ #category : #accessing }
LanguageLinkCommand >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
LanguageLinkCommand >> transformBlock: anObject [
	transformBlock := anObject
]
