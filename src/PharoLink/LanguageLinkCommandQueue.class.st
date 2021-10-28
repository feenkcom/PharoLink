Class {
	#name : #LanguageLinkCommandQueue,
	#superclass : #Object,
	#instVars : [
		'currentIndex',
		'innerCollection',
		'executionHandler'
	],
	#category : 'PharoLink-Execution'
}

{ #category : #accessing }
LanguageLinkCommandQueue class >> executionHandler: aHandler [
	^ self new
			executionHandler: aHandler;
			yourself
]

{ #category : #accessing }
LanguageLinkCommandQueue >> cleanIndex: anIndex [
"	self debugMode ifTrue: [ ^ self ]."
	currentIndex := currentIndex - 1.
	innerCollection removeAt: anIndex
]

{ #category : #accessing }
LanguageLinkCommandQueue >> completedCommands [
	^ innerCollection first: currentIndex
]

{ #category : #accessing }
LanguageLinkCommandQueue >> currentCommand [
	self isFinished ifTrue: [ ^ nil ].
	^ innerCollection at: currentIndex
]

{ #category : #accessing }
LanguageLinkCommandQueue >> debugMode [
	^ executionHandler debugMode
]

{ #category : #accessing }
LanguageLinkCommandQueue >> enqueueCommand: aCommand [
	innerCollection add: aCommand
]

{ #category : #accessing }
LanguageLinkCommandQueue >> excecutionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkCommandQueue >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkCommandQueue >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #accessing }
LanguageLinkCommandQueue >> finishCommand: aCommand [
	^ self finishCommandId: aCommand id
]

{ #category : #accessing }
LanguageLinkCommandQueue >> finishCommandId: id [
	| commandIndex |
	self currentCommand
		ifNotNil: [ :command | 
			command id = id
				ifTrue: [ self cleanIndex: currentIndex.
					currentIndex := currentIndex + 1.
					^ true ] ].
	commandIndex := innerCollection
		detectIndex: [ :command | command id = id ].
	commandIndex > currentIndex
		ifTrue: [ currentIndex := commandIndex + 1.
			self
				trace:
					(LanguageLinkErrorLog
						message: 'Out of sync command queue. Pharo is delayed.') ]
		ifFalse: [ self
				trace:
					(LanguageLinkErrorLog
						message: 'Out of sync command queue. Python is delayed.') ].
	self cleanIndex: commandIndex.
	^ false
]

{ #category : #accessing }
LanguageLinkCommandQueue >> getCommand: aCommandId [
	^ innerCollection detect: [ :command | command id = aCommandId ]
]

{ #category : #initialization }
LanguageLinkCommandQueue >> initialize [
	super initialize.
	innerCollection := OrderedCollection new.
	currentIndex := 1
]

{ #category : #accessing }
LanguageLinkCommandQueue >> isFinished [
	^ innerCollection size < currentIndex
]

{ #category : #accessing }
LanguageLinkCommandQueue >> list [
	^ innerCollection
]

{ #category : #accessing }
LanguageLinkCommandQueue >> nextCommand [
	| nextCommandIndex |
	nextCommandIndex := currentIndex + 1.
	innerCollection size < nextCommandIndex ifTrue: [ ^ nil ].
	^ innerCollection at: nextCommandIndex
]

{ #category : #printing }
LanguageLinkCommandQueue >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '(';
		print: innerCollection size;
		<< ' raw items)'
]

{ #category : #accessing }
LanguageLinkCommandQueue >> queue [
	^ self waitingCommands
]

{ #category : #accessing }
LanguageLinkCommandQueue >> waitingCommands [
	^ innerCollection allButFirst: currentIndex
]
