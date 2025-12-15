Class {
	#name : #PharoLinkNetworkErrorSignal,
	#superclass : #PharoLinkSignal,
	#instVars : [
		'command',
		'networkError'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #'instance creation' }
PharoLinkNetworkErrorSignal class >> emitCommand: aPharoLinkEvalCommand error: anError [

	^ self new
		command: aPharoLinkEvalCommand;
		networkError: anError;
		emit.
]

{ #category : #accessing }
PharoLinkNetworkErrorSignal >> command [
	^ command
]

{ #category : #accessing }
PharoLinkNetworkErrorSignal >> command: anObject [
	command := anObject
]

{ #category : #accessing }
PharoLinkNetworkErrorSignal >> networkError [
	^ networkError
]

{ #category : #accessing }
PharoLinkNetworkErrorSignal >> networkError: anObject [
	networkError := anObject
]

{ #category : #printing }
PharoLinkNetworkErrorSignal >> printOn: aStream [

	self printOneLineOn: aStream.
	aStream 
		<< command blockString;
		cr.
]

{ #category : #printing }
PharoLinkNetworkErrorSignal >> printOneLineContentsOn: stream [

	stream 
		<< 'error: ';
		<< networkError messageText.
]
