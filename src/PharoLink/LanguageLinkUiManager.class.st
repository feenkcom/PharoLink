Class {
	#name : 'LanguageLinkUiManager',
	#superclass : 'Object',
	#category : 'PharoLink-Platform'
}

{ #category : 'hooks' }
LanguageLinkUiManager >> notify: aString [
	self subclassResponsibility
]

{ #category : 'hooks' }
LanguageLinkUiManager >> spawnDebuggerOnException: anException [
	self subclassResponsibility
]
