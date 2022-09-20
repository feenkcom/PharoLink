Class {
	#name : #LanguageLinkCommandFactory,
	#superclass : #Object,
	#traits : 'TGtPharoLinkPlayground',
	#classTraits : 'TGtPharoLinkPlayground classTrait',
	#instVars : [
		'application',
		'bindingsDictionary',
		'observers',
		'transformBlock',
		'command',
		'instructions'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #'instance creation' }
LanguageLinkCommandFactory class >> application: aLLApplication [

	^ self new application: aLLApplication
]

{ #category : #streaming }
LanguageLinkCommandFactory >> << anLLStatement [
	instructions add: anLLStatement
]

{ #category : #bindings }
LanguageLinkCommandFactory >> addBinding: aBinding [
	bindingsDictionary at: aBinding key put: aBinding object.
	^ aBinding
]

{ #category : #observers }
LanguageLinkCommandFactory >> addObserver: anObserver [
	observers add: anObserver.
	^ anObserver
]

{ #category : #streaming }
LanguageLinkCommandFactory >> append: aPythonStatement [
	instructions add: aPythonStatement
]

{ #category : #accessing }
LanguageLinkCommandFactory >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkCommandFactory >> application: aLLApplication [

	application := aLLApplication.
	self reset.
]

{ #category : #bindings }
LanguageLinkCommandFactory >> bindingAt: varName put: anObject [

	^ self subclassResponsibility 
]

{ #category : #bindings }
LanguageLinkCommandFactory >> bindingWrap: anObject [

	^ self subclassResponsibility 
]

{ #category : #send }
LanguageLinkCommandFactory >> buildCommand [
	| finishedCommand |
	finishedCommand := command
								instructions: self instructionsWithNotifyAtEnd;
								bindings: bindingsDictionary;
								observers: observers;
								transformBlock: transformBlock;
								yourself.
	self reset.
	^ finishedCommand
]

{ #category : #accessing }
LanguageLinkCommandFactory >> decorateTransform: aBlock [
	| previousBlock |
	previousBlock := transformBlock.
	^ transformBlock := [ :obj | aBlock value: (previousBlock value: obj) ]
]

{ #category : #logging }
LanguageLinkCommandFactory >> emitSendCommandCompletedSignalWithInstructions: currentInstructions andBindings: currentBindings [
	(LanguageLinkSendCommandSignal forCommandFactory:  self) 
		markAsEndSignal;
		instructions: currentInstructions;
		bindingsDictionary: currentBindings;
		emit
]

{ #category : #logging }
LanguageLinkCommandFactory >> emitSendCommandInitiatedSignal [
	(LanguageLinkSendCommandSignal forCommandFactory:  self)
		markAsStartSignal;
		instructions: instructions;
		bindingsDictionary: bindingsDictionary;
		emit
]

{ #category : #accessing }
LanguageLinkCommandFactory >> instructionsWithNotifyAtEnd [
	| instructionsCopy |

	instructionsCopy := instructions copy.
	instructionsCopy ifEmpty: [ instructionsCopy := OrderedCollection with: nil ].
	instructionsCopy last isLanguageLinkValue ifFalse: [ 
		instructionsCopy := instructionsCopy asOrderedCollection.
		instructionsCopy add: nil ].
	instructionsCopy 
		at: instructionsCopy size 
		put: (self setNotifyToInstruction: instructionsCopy last).
	^ instructionsCopy
]

{ #category : #observers }
LanguageLinkCommandFactory >> observerFromCallback: aBlock [
	| observer |
	observer := (LanguageLinkObserver callback: aBlock)
						command: command;
						yourself.
	^ self addObserver: observer
]

{ #category : #send }
LanguageLinkCommandFactory >> performSendWithLogging: aBlock [
	| commandResult currentInstructions currentBindings |
	
	currentInstructions := instructions.
	currentBindings := bindingsDictionary.
	
	self emitSendCommandInitiatedSignal.
	commandResult := aBlock value.
	self 
		emitSendCommandCompletedSignalWithInstructions: currentInstructions 
		andBindings: currentBindings.
	
	^ commandResult 
]

{ #category : #initialization }
LanguageLinkCommandFactory >> reset [

	instructions := OrderedCollection new.
	bindingsDictionary := Dictionary new.
	observers := OrderedCollection new.
	command := self application newCommand.
	transformBlock := #yourself
]

{ #category : #send }
LanguageLinkCommandFactory >> send [
	^ self performSendWithLogging: [ self sendCommand ]
]

{ #category : #send }
LanguageLinkCommandFactory >> send: aStatement [

	self << aStatement.
	^ self performSendWithLogging: [ self sendCommand ]
]

{ #category : #send }
LanguageLinkCommandFactory >> sendAndWait [
	^ self performSendWithLogging: [ self sendCommand waitForValue ]
]

{ #category : #send }
LanguageLinkCommandFactory >> sendAndWait: aStatement [

	self << aStatement.
	^ self performSendWithLogging: [ self sendCommand waitForValue ]
]

{ #category : #send }
LanguageLinkCommandFactory >> sendCommand [
	^ self application send: self buildCommand
]

{ #category : #initialization }
LanguageLinkCommandFactory >> setNotifyImmediateToInstruction: aJSgInstruction [
	^ 'notify_immediate' asJSGIdentifier 
			jsCallWith: (Array with: aJSgInstruction with: command id)
]

{ #category : #initialization }
LanguageLinkCommandFactory >> setNotifyToInstruction: aP3gInstruction [
	^ 'notify' asJSGIdentifier 
			jsCallWith: (Array with: aP3gInstruction with: command id)
]

{ #category : #accessing }
LanguageLinkCommandFactory >> settings [ 
	^ self application settings
]

{ #category : #accessing }
LanguageLinkCommandFactory >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
LanguageLinkCommandFactory >> transformBlock: anObject [
	transformBlock := anObject
]
