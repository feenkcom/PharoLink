Class {
	#name : #PharoLinkDebuggerPaused,
	#superclass : #PharoLinkRemoteNotification,
	#instVars : [
		'debuggerClient'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : #signalling }
PharoLinkDebuggerPaused class >> signalDebugger: aDebugger [

	^ self new 
		debugger: aDebugger;
		signal
]

{ #category : #accessing }
PharoLinkDebuggerPaused >> debuggerClient [

	^ debuggerClient
]

{ #category : #accessing }
PharoLinkDebuggerPaused >> debuggerClient: anObject [
	debuggerClient := anObject
]

{ #category : #exceptiondescription }
PharoLinkDebuggerPaused >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ UnhandledError signalForException: self
]

{ #category : #testing }
PharoLinkDebuggerPaused >> isPaused [
	"Answer a boolean indicating whether the receiver represents an exception that can be debugged / continued.
	Only PharoLinkDebuggerPaused can be continued"

	^ true

]

{ #category : #initialization }
PharoLinkDebuggerPaused >> setWaitAgain [
	"Flag the receiver's promise that it should wait for another value"

	promise setWaitAgain.
]
