Class {
	#name : #LanguageLinkCommandQueueTest,
	#superclass : #PharoLinkTestCase,
	#instVars : [
		'queue'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #initialization }
LanguageLinkCommandQueueTest >> setUp [
	| execHandler |

	super setUp.
	execHandler := LanguageLinkExecutionHandler basicNew 
							application: self application;
							yourself.
	queue := LanguageLinkCommandQueue executionHandler: execHandler
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testCleaningCommand [
	| cc1 cc2 |
	cc1 := LanguageLinkCommand new.
	cc2 := LanguageLinkCommand new.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self assert: (queue finishCommand: cc1).
	self assert: queue list size equals: 1.
	self assert: (queue finishCommand: cc2).
	self assert: queue isFinished
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testEmptyQueue [
	self assert: queue list isEmpty.
	self assert: queue isFinished.
	self assert: queue currentCommand isNil
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testEnqueue [
	| c |
	c := LanguageLinkCommand new.
	queue enqueueCommand: c.
	self assert: queue list size equals: 1.
	self assert: queue currentCommand equals: c.
	
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testFinishCommand [
	| cc |
	cc := LanguageLinkCommand new.
	queue enqueueCommand: cc.
	self assert: (queue finishCommand: cc).
	self assert: queue isFinished
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testFinishCommand2 [
	| cc |
	cc := LanguageLinkCommand new.
	queue enqueueCommand: cc.
	queue enqueueCommand: LanguageLinkCommand new.
	self assert: (queue finishCommand: cc).
	self deny: queue isFinished
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testFinishNotFoundCommand [
	self 
		should: [ queue finishCommandId: 'aa' ]
		raise: Error
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testFinishOutOfSync1Command [
	| cc1 cc2 |
	cc1 := self newCommand.
	cc2 := self newCommand.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self deny: (queue finishCommand: cc2).
	self assert: queue isFinished
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testFinishOutOfSync2Command [
	| cc1 cc2 |
	cc1 := self newCommand.
	cc2 := self newCommand.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self deny: (queue finishCommand: cc2).
	self deny: (queue finishCommand: cc1).
	self assert: queue isFinished
]

{ #category : #tests }
LanguageLinkCommandQueueTest >> testNotFoundCommand [
	queue enqueueCommand: LanguageLinkCommand new.
	self 
		should: [ queue finishCommandId: 'aa' ]
		raise: Error
]
