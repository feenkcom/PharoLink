Class {
	#name : #LanguageLinkPharoUiManager,
	#superclass : #LanguageLinkUiManager,
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
