Class {
	#name : #LanguageLinkPromise,
	#superclass : #Object,
	#instVars : [
		'id',
		'semaphore',
		'transformBlock',
		'value',
		'waitAgain',
		'timeout'
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
LanguageLinkPromise >> exception [
	"Answer the receiver's exception, nil if there isn't one"

	^ (value isKindOf: Exception) 
		ifTrue: [ value ]
		ifFalse: [  ].

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
LanguageLinkPromise >> setWaitAgain [ 
	"Flag that the promise should wait for the real value to be returned from the server"

	waitAgain := true.
	semaphore consumeAllSignals.
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
LanguageLinkPromise >> timeout [
	^ timeout
]

{ #category : #accessing }
LanguageLinkPromise >> timeout: aDuration [
	timeout := aDuration
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

{ #category : #accessing }
LanguageLinkPromise >> wait [
	"Wait for the promise to be fulfiller, but don't process the result"

	timeout ifNil: [ semaphore wait. ^ self ].
	(semaphore waitTimeoutMSecs: timeout asMilliSeconds) ifTrue:
		[ TimedOut signal ].
]

{ #category : #accessing }
LanguageLinkPromise >> waitAgain [
	"Answer a boolean indicating whether the promise should wait again for a value.
	This is typically used if an exception was raised by the server, e.g. PharoLinkDebuggerPaused, and the exception has been resolved and the server will later return the result of the original request."
	<return: #Boolean>

	^ waitAgain
]

{ #category : #accessing }
LanguageLinkPromise >> waitAgain: aBoolean [

	waitAgain := aBoolean
]

{ #category : #signalling }
LanguageLinkPromise >> waitForValue [
	"Wait for the server to supply the result and answer it.
	If the value is an exception, the issue may be resolved and the promise flagged to wait for the new value to come through (waitAgain)."
	<remoteDebuggerSignal>

	[ waitAgain := false.
	self isSignaled ifFalse: [ self wait ].
	(value isKindOf: Exception) ifTrue:
		[ value isPharoLinkNotification ifTrue: [ value promise: self ].
		value copy signal ].
	"If an exception was signalled, it may request that the promise wait for the real value to come through."
	waitAgain ] whileTrue.
	^ value
]
