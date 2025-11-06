Class {
	#name : #LlEsConnectCompletedSignal,
	#superclass : #LlEsConnectSignal,
	#instVars : [
		'isConnected'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LlEsConnectCompletedSignal >> initializeFromTimestamp: aDateAndTime andData: aCollection [ 

	super initializeFromTimestamp: aDateAndTime andData: aCollection.
	isConnected := aCollection at: 3.
]

{ #category : #accessing }
LlEsConnectCompletedSignal >> isConnected [
	^ isConnected
]

{ #category : #accessing }
LlEsConnectCompletedSignal >> isConnected: anObject [
	isConnected := anObject
]

{ #category : #testing }
LlEsConnectCompletedSignal >> isEndSignalType [
	^ true
]

{ #category : #printing }
LlEsConnectCompletedSignal >> printOneLineContentsOn: stream [

	super printOneLineContentsOn: stream.
	stream 
		<< ' | ';
		<< isConnected asString
]
