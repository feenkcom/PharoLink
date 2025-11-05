Class {
	#name : #LanguageLinkCommandRegistryTest,
	#superclass : #PharoLinkTestCase,
	#instVars : [
		'registry'
	],
	#category : 'PharoLink-Tests'
}

{ #category : #initialization }
LanguageLinkCommandRegistryTest >> setUp [
	| execHandler |

	super setUp.
	execHandler := LanguageLinkExecutionHandler basicNew 
							application: self application;
							yourself.
	registry := LanguageLinkCommandRegistry executionHandler: execHandler
]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testCleaningCommand [
	| cc1 cc2 |
	cc1 := LanguageLinkCommand forApplication: application.
	cc2 := LanguageLinkCommand forApplication: application.
	registry addCommand: cc1.
	registry addCommand: cc2.
	self assert: (registry finishCommand: cc1).
	self assert: registry size equals: 1.
	self assert: (registry finishCommand: cc2).
	self assert: registry size equals: 0.
]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testEmptyQueue [
	self assert: registry size equals: 0.

]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testEnqueue [
	| c |
	c := LanguageLinkCommand forApplication: application.
	registry addCommand: c.
	self assert: registry size equals: 1.
	self assert: (registry getCommand: c id) equals: c.
	
]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testFinishCommand [
	| cc |
	cc := LanguageLinkCommand new.
	registry addCommand: cc.
	self assert: (registry finishCommand: cc).
	self assert: registry isEmpty
]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testFinishCommand2 [
	| cc |
	cc := LanguageLinkCommand forApplication: application.
	registry addCommand: cc.
	registry addCommand: (LanguageLinkCommand forApplication: application).
	self assert: (registry finishCommand: cc).
	self deny: registry isEmpty
]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testFinishNotFoundCommand [
	self 
		should: [ registry finishCommandId: 'aa' ]
		raise: Error
]

{ #category : #tests }
LanguageLinkCommandRegistryTest >> testNotFoundCommand [
	registry addCommand: LanguageLinkCommand new.
	self 
		should: [ registry finishCommandId: 'aa' ]
		raise: Error
]
