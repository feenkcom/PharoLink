Class {
	#name : #LanguageLinkEventSignal,
	#superclass : #LanguageLinkSignal,
	#category : 'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkEventSignal class >> eventType [
	^ GtBeaconLogEvent
]

{ #category : #initialization }
LanguageLinkEventSignal >> initializeFromTimestamp: aDateAndTime andData: aCollection [ 
	timestamp := aDateAndTime.
	processId := aCollection second.
]

{ #category : #testing }
LanguageLinkEventSignal >> isEndSignalType [
	^ false
]

{ #category : #testing }
LanguageLinkEventSignal >> isStartSignalType [
	^ false
]

{ #category : #accessing }
LanguageLinkEventSignal >> matchingSignalFrom: candidateEvents [
	"Answer the receiver's match from the supplied signals.
	The collection is expected to typically be small and contain the match.
	The default is to match on processId, or if there is only a single candidate, accept that."

	candidateEvents 
		detect:  [ :each | each eventStartedSignal processId = self processId ]
		ifFound: [ :event | ^ event].
	candidateEvents size = 1 ifTrue:
			[ ^ candidateEvents first ].
	^ nil
]

{ #category : #printing }
LanguageLinkEventSignal >> printOneLineContentsOn: stream [
	stream 
		<< '| ';
		<< self signalTypeLabel;
		<< ' | ';
		<< self processId
]

{ #category : #accessing }
LanguageLinkEventSignal >> signalTypeLabel [

	^ 'LanguageLinkEventSignal'
]
