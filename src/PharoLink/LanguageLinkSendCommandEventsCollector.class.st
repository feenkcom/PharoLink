Class {
	#name : #LanguageLinkSendCommandEventsCollector,
	#superclass : #GtBeaconEventsCollector,
	#category : #'PharoLink-Logging'
}

{ #category : #initialization }
LanguageLinkSendCommandEventsCollector >> createDefaultEventsGrouper [
	^ LanguageLinkSendCommandEventsGrouper new
]

{ #category : #initialization }
LanguageLinkSendCommandEventsCollector >> defaultSignalType [
	^ LanguageLinkSendCommandSignal, LanguageLinkDeliverCommandSignal
]

{ #category : #accessing }
LanguageLinkSendCommandEventsCollector >> gtCommandsFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Commands';
		priority: 7;
		object: [ eventsGrouper ];
		view: #gtCommandsFor:
]

{ #category : #initialization }
LanguageLinkSendCommandEventsCollector >> relevantSignalType [
	^ LanguageLinkSendCommandSignal, LanguageLinkDeliverCommandSignal
]
