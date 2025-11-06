Class {
	#name : #LanguageLinkSendCommandEventsGrouper,
	#superclass : #GtBeaconEventsGrouper,
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkSendCommandEventsGrouper >> createDefaultEventsGroup [
	^ LanguageLinkSendCommandEventsGroup new
]

{ #category : #accessing }
LanguageLinkSendCommandEventsGrouper >> gtCommandsFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Commands';
		priority: 7;
		object: [ self rootEvents ];
		view: #gtCommandsFor:
]
