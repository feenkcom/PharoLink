Class {
	#name : #PharoLinkDebuggerPaused,
	#superclass : #PharoLinkRemoteNotification,
	#instVars : [
		'dapDebugger'
	],
	#category : #'PharoLink-ErrorHandling'
}

{ #category : #signalling }
PharoLinkDebuggerPaused class >> signalDebugger: aDebugger [

	^ self new 
		debugger: aDebugger;
		signal
]

{ #category : #accessing }
PharoLinkDebuggerPaused >> dapDebugger [
	^ dapDebugger
]

{ #category : #accessing }
PharoLinkDebuggerPaused >> dapDebugger: anObject [
	dapDebugger := anObject
]

{ #category : #exceptiondescription }
PharoLinkDebuggerPaused >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ UnhandledError signalForException: self
]

{ #category : #initialization }
PharoLinkDebuggerPaused >> setWaitAgain [
	"Flag the receiver's promise that it should wait for another value"

	promise setWaitAgain.
]
