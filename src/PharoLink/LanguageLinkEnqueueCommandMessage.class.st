Class {
	#name : #LanguageLinkEnqueueCommandMessage,
	#superclass : #LanguageLinkAsyncMessage,
	#instVars : [
		'commandId',
		'statements',
		'bindings'
	],
	#category : #'PharoLink-Platform-Messages'
}

{ #category : #'as yet unclassified' }
LanguageLinkEnqueueCommandMessage class >> commandId: commandId statements: statements bindings: bindings [
	^ self new
			commandId: commandId;
			statements: statements;
			bindings: bindings;
			yourself
]

{ #category : #'as yet unclassified' }
LanguageLinkEnqueueCommandMessage class >> type [
	^ 'ENQUEUE'
]

{ #category : #adding }
LanguageLinkEnqueueCommandMessage >> addBinding: assoc [
	bindings add: assoc
]

{ #category : #adding }
LanguageLinkEnqueueCommandMessage >> addBindings: assocs [
	assocs do: [ :assoc | self addBinding: assoc ]
]

{ #category : #accessing }
LanguageLinkEnqueueCommandMessage >> bindings [
	^ bindings
]

{ #category : #accessing }
LanguageLinkEnqueueCommandMessage >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
LanguageLinkEnqueueCommandMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
LanguageLinkEnqueueCommandMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #adding }
LanguageLinkEnqueueCommandMessage >> initialize [
	super initialize.
	bindings := Dictionary new
]

{ #category : #adding }
LanguageLinkEnqueueCommandMessage >> privateEncode: dict [
	dict at: #commandId put: commandId.
	dict at: #statements put: statements.
	dict at: #bindings put: bindings
]

{ #category : #accessing }
LanguageLinkEnqueueCommandMessage >> statements [
	^ statements
]

{ #category : #accessing }
LanguageLinkEnqueueCommandMessage >> statements: anObject [
	statements := anObject
]
