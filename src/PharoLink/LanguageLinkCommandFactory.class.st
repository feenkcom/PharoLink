Class {
	#name : #LanguageLinkCommandFactory,
	#superclass : #Object,
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

{ #category : #ui }
LanguageLinkCommandFactory >> evaluateSourceSequence: aString [

	"self addPlaygroundBindings."
	self << aString.
	^ self sendAndWait.

]

{ #category : #ui }
LanguageLinkCommandFactory >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		priority: 10;
		text: [ '' asRopedText attributesBuilder attribute: (BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler) ];
		styler: application settings parserClass gtStyler;
		actionButtonIcon: BrGlamorousIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				result := [ self evaluateSourceSequence: statements ]
					on: PharoLinkRemoteError, PharoLinkParserError
					do: [ :ex | ex ].
				aButton phlow spawnObject: result ].

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
	^ self sendCommand
]

{ #category : #send }
LanguageLinkCommandFactory >> send: aStatement [

	self << aStatement.
	^ self sendCommand
]

{ #category : #send }
LanguageLinkCommandFactory >> sendAndWait [
	^ self sendCommand waitForValue
]

{ #category : #send }
LanguageLinkCommandFactory >> sendAndWait: aStatement [

	self << aStatement.
	^ self sendCommand waitForValue
]

{ #category : #send }
LanguageLinkCommandFactory >> sendCommand [
	^ self application send: self buildCommand
]

{ #category : #initialization }
LanguageLinkCommandFactory >> setNotifyImmediateToInstruction: aJSgInstruction [
	^ 'notify_immediate' asJSGIdentifier 
			callWith: (Array with: aJSgInstruction with: command id)
]

{ #category : #initialization }
LanguageLinkCommandFactory >> setNotifyToInstruction: aP3gInstruction [
	^ 'notify' asJSGIdentifier 
			callWith: (Array with: aP3gInstruction with: command id)
]

{ #category : #accessing }
LanguageLinkCommandFactory >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
LanguageLinkCommandFactory >> transformBlock: anObject [
	transformBlock := anObject
]
