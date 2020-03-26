Class {
	#name : #LanguageLinkPharoUiManager,
	#superclass : #JSLinkUiManager,
	#category : #'PharoLink-Pharo-Platform'
}

{ #category : #'as yet unclassified' }
LanguageLinkPharoUiManager >> notify: aString [
	Transcript show: aString asString.
]

{ #category : #hooks }
LanguageLinkPharoUiManager >> spawnDebuggerOnException: anException [
	^ UnhandledError signalForException: anException
]
