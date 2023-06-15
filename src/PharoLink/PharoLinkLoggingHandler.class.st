Class {
	#name : #PharoLinkLoggingHandler,
	#superclass : #LanguageLinkHandler,
	#category : 'PharoLink-Core'
}

{ #category : #logging }
PharoLinkLoggingHandler >> log: aLogMessage [

	aLogMessage asBeaconSignal emit
]
