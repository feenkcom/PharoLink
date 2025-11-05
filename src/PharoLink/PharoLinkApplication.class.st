Class {
	#name : #PharoLinkApplication,
	#superclass : #LanguageLinkApplication,
	#category : 'PharoLink-Global'
}

{ #category : #initialization }
PharoLinkApplication >> initializeHandlers [

	loggingHandler := PharoLinkLoggingHandler application: self.
	communicationHandler := LanguageLinkCommunicationHandler application: self.
	processHandler := LanguageLinkServerHandler application: self.
	executionHandler := PharoLinkExecutionHandler application: self
]

{ #category : #initialization }
PharoLinkApplication >> platformClass [

	^ PharoLinkPlatform
]

{ #category : #registering }
PharoLinkApplication >> proxyForObject: anObject [

	^ self newCommandFactory
		bindingAt: #serializedObject put: (LeJsonV4 uniqueInstance serialize: anObject);
		<< 'LeJsonV4 uniqueInstance deserialize:  serializedObject readStream';
		sendAndWait.
]
