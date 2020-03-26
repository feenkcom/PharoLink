Class {
	#name : #LanguageLinkPromise,
	#superclass : #Object,
	#instVars : [
		'id',
		'semaphore',
		'transformBlock',
		'value'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #accessing }
LanguageLinkPromise class >> id: id [
	^ self new
			id: id;
			yourself
]

{ #category : #accessing }
LanguageLinkPromise >> id [
	^ id
]

{ #category : #accessing }
LanguageLinkPromise >> id: anObject [
	id := anObject
]

{ #category : #initialization }
LanguageLinkPromise >> initialize [
	super initialize.
	semaphore := Semaphore new.
	value := nil.
	transformBlock := #yourself
]

{ #category : #signalling }
LanguageLinkPromise >> isSignaled [
	^ semaphore isSignaled
]

{ #category : #signalling }
LanguageLinkPromise >> signalAll [
	1 to: semaphore size + 20 do: [ :s | semaphore signal ]
]

{ #category : #signalling }
LanguageLinkPromise >> signalWithValue: anObject [
	value := transformBlock value: anObject.
	self signalAll.
]

{ #category : #accessing }
LanguageLinkPromise >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
LanguageLinkPromise >> transformBlock: anObject [
	transformBlock := anObject
]

{ #category : #signalling }
LanguageLinkPromise >> value [
	^ value
]

{ #category : #signalling }
LanguageLinkPromise >> waitForValue [

	self isSignaled ifFalse: [ semaphore wait ].
	(value isKindOf: Exception) ifTrue:
		[ value copy signal ].
	^ self value
]
