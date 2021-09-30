Class {
	#name : #PharoLinkApplicationTestResource,
	#superclass : #TestResource,
	#instVars : [
		'application',
		'commandFactory'
	],
	#category : 'PharoLink-Tests'
}

{ #category : #initialization }
PharoLinkApplicationTestResource >> application [
	^ application
]

{ #category : #accessing }
PharoLinkApplicationTestResource >> commandFactory [
	^ commandFactory
]

{ #category : #initialization }
PharoLinkApplicationTestResource >> setUp [
	super setUp.
	application := PharoLinkApplication newWith: LanguageLinkSettings pharoDefaultSettings.
	application settings debugMode: true.
	application start.
	commandFactory := application newCommandFactory.

]

{ #category : #initialization }
PharoLinkApplicationTestResource >> tearDown [
	application stop.
	super tearDown.
]
