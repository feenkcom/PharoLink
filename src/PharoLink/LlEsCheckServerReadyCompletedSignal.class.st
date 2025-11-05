Class {
	#name : #LlEsCheckServerReadyCompletedSignal,
	#superclass : #LlEsCheckServerReadySignal,
	#instVars : [
		'isServerReady'
	],
	#category : 'PharoLink-Logging'
}

{ #category : #initialization }
LlEsCheckServerReadyCompletedSignal >> initializeFromTimestamp: aDateAndTime andData: aCollection [ 

	super initializeFromTimestamp: aDateAndTime andData: aCollection.
	isServerReady := aCollection at: 3.
]

{ #category : #testing }
LlEsCheckServerReadyCompletedSignal >> isEndSignalType [
	^ true
]

{ #category : #accessing }
LlEsCheckServerReadyCompletedSignal >> isServerReady [
	^ isServerReady
]

{ #category : #accessing }
LlEsCheckServerReadyCompletedSignal >> isServerReady: anObject [
	isServerReady := anObject
]

{ #category : #printing }
LlEsCheckServerReadyCompletedSignal >> printOneLineContentsOn: stream [

	super printOneLineContentsOn: stream.
	stream 
		<< ' | ';
		<< isServerReady asString
]
