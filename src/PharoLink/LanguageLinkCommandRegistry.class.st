"
LanguageLinkCommandRegistry provides a simple mapping from a commandId to a command, i.e. a Dictionary.

It was previously called LanguageLinkCommandQueue and enforced commands to be completed in the order that they were started, however this is imposing a constraint on the server which is not necessarily required, and prevents the possibility of having an open observer.
"
Class {
	#name : #LanguageLinkCommandRegistry,
	#superclass : #Object,
	#instVars : [
		'executionHandler',
		'dictionary',
		'mutex'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #accessing }
LanguageLinkCommandRegistry class >> executionHandler: aHandler [
	^ self new
			executionHandler: aHandler;
			yourself
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> addCommand: aCommand [

	mutex critical:
		[ dictionary at: aCommand id put: aCommand ]
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> debugMode [
	^ executionHandler debugMode
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> finishCommand: aCommand [
	^ self finishCommandId: aCommand id
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> finishCommandId: id [

	mutex critical: [ dictionary removeKey: id ].
	^ true.

]

{ #category : #accessing }
LanguageLinkCommandRegistry >> getCommand: aCommandId [

	^ mutex critical: [ dictionary at: aCommandId ]
]

{ #category : #initialization }
LanguageLinkCommandRegistry >> initialize [
	super initialize.
	dictionary := Dictionary new.
	mutex := Mutex new.
]

{ #category : #testing }
LanguageLinkCommandRegistry >> isEmpty [

	^ dictionary isEmpty
]

{ #category : #printing }
LanguageLinkCommandRegistry >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '(';
		print: dictionary size;
		<< ' raw items)'
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> queue [
	^ self waitingCommands
]

{ #category : #accessing }
LanguageLinkCommandRegistry >> size [

	^ dictionary size
]
