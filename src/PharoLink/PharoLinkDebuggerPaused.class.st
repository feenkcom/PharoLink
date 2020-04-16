Class {
	#name : #PharoLinkDebuggerPaused,
	#superclass : #Notification,
	#instVars : [
		'debugger'
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
PharoLinkDebuggerPaused >> debugger [
	^ debugger
]

{ #category : #accessing }
PharoLinkDebuggerPaused >> debugger: anObject [
	debugger := anObject
]
