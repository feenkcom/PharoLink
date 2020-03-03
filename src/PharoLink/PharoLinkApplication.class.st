Class {
	#name : #PharoLinkApplication,
	#superclass : #LanguageLinkApplication,
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
PharoLinkApplication >> commandFactory [

	self deprecated: 'Use #newCommandFactory'.
	^ PharoLinkCommandFactory application: self.
]

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
