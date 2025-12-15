"
LanguageLinkLoggingHandler provides a simple store of log messages.  It is easy to port between Smalltalk dialects, but provides little functionality.

"
Class {
	#name : #LanguageLinkLoggingHandler,
	#superclass : #LanguageLinkHandler,
	#instVars : [
		'logs'
	],
	#category : #'PharoLink-Core'
}

{ #category : #accessing }
LanguageLinkLoggingHandler >> errorLogs [
	^ logs select: #isError
]

{ #category : #initialization }
LanguageLinkLoggingHandler >> initialize [
	super initialize.
	logs := OrderedCollection new
]

{ #category : #log }
LanguageLinkLoggingHandler >> log: aLog [
	logs add: aLog
]

{ #category : #accessing }
LanguageLinkLoggingHandler >> logs [
	^ logs
]
