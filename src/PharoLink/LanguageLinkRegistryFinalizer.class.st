Class {
	#name : #LanguageLinkRegistryFinalizer,
	#superclass : #LanguageLinkAbstractFinalizer,
	#instVars : [
		'executionHandler',
		'proxyObjectId'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #accessing }
LanguageLinkRegistryFinalizer class >> javaScriptVariable: aPythonVariable executionHandler: executionHandler [
	^ self new
		proxyObjectId: aPythonVariable;
		executionHandler: executionHandler
		yourself
]

{ #category : #accessing }
LanguageLinkRegistryFinalizer >> application [ 

	^ executionHandler application
]

{ #category : #accessing }
LanguageLinkRegistryFinalizer >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkRegistryFinalizer >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #finalization }
LanguageLinkRegistryFinalizer >> finalize [
	| cf |
	self application isRunning ifFalse: 
		[ ^ self ].
	cf := executionHandler newCommandFactory.
	cf << (executionHandler removeId: proxyObjectId).
	[ cf send ]
		on: LanguageLinkCommunicationError
		do: [ :ex |
			"The application may have closed down, if it has ignore the error"
			self application isRunning ifTrue: [ ex pass ] ].
]

{ #category : #accessing }
LanguageLinkRegistryFinalizer >> proxyObjectId [
	^ proxyObjectId
]

{ #category : #accessing }
LanguageLinkRegistryFinalizer >> proxyObjectId: anObject [
	proxyObjectId := anObject
]
