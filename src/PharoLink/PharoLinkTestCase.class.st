Class {
	#name : 'PharoLinkTestCase',
	#superclass : 'LanguageLinkTestCase',
	#category : 'PharoLink-Tests'
}

{ #category : 'running' }
PharoLinkTestCase >> setUp [
	super setUp.
	application := PharoLinkApplication newWith: LanguageLinkSettings pharoDefaultSettings.
	commandFactory := application newCommandFactory.
	self cf reset.
]
