Class {
	#name : #LanguageLinkTestCase,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'commandFactory',
		'promise'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #initialization }
LanguageLinkTestCase >> app [
	^ self application
]

{ #category : #initialization }
LanguageLinkTestCase >> application [
	^ application
]

{ #category : #asserting }
LanguageLinkTestCase >> assertClass: cls name: aName [
	self cf << (cls => #__name__).
	self assert: self cf send waitForValue equals: aName
]

{ #category : #asserting }
LanguageLinkTestCase >> assertExpression: expr equals: aBlockOrValue [
	self cf << expr.
	self assert: self cf send waitForValue equals: aBlockOrValue value
]

{ #category : #asserting }
LanguageLinkTestCase >> assertInstanceClass: obj name: aName [

	self cf << (obj => #constructor => #name).
	"self cf << ((#type asP3GI callWith: (Array with: obj)) => #__name__)."
	self assert: self cf send waitForValue equals: aName
]

{ #category : #initialization }
LanguageLinkTestCase >> cf [
	^ self commandFactory
]

{ #category : #initialization }
LanguageLinkTestCase >> cfSend [
	^ promise := self cf send
]

{ #category : #initialization }
LanguageLinkTestCase >> commandFactory [
	^ commandFactory
]

{ #category : #'instance creation' }
LanguageLinkTestCase >> newCommand [ 

	^ self application newCommand.
]

{ #category : #asserting }
LanguageLinkTestCase >> registryExpression [
	^ #registry callWith: #()
]

{ #category : #asserting }
LanguageLinkTestCase >> resolveId: anId [
	^ self registryExpression => #resolve callWith: (Array with: anId)
]

{ #category : #running }
LanguageLinkTestCase >> setUp [
	super setUp.
	application := PharoLinkApplication newWith: LanguageLinkSettings pharoDefaultSettings.
	commandFactory := application newCommandFactory.
	self cf reset.
]
