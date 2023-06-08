Class {
	#name : #LanguageLinkSendCommandEventsGroup,
	#superclass : #GtBeaconLogEventsGroup,
	#category : #'PharoLink-Logging'
}

{ #category : #'gt - extensions' }
LanguageLinkSendCommandEventsGroup >> gtCommandsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Commands';
		priority: 7;
		items: [ self ];
		column: 'Timestamp' text: #timestamp  width: 200;
		column: 'Process' text: #processId width: 150;
		column: 'Receiver' text: [ :aEvent |
			aEvent remoteReceiverDescription ifNil: [ '-' ] ];
		column: 'Command String' text: [ :anEvent | anEvent commandString ];
		column: 'Duration' 
			text: [ :anEvent | anEvent duration ] width: 150
]

{ #category : #'gt - extensions' }
LanguageLinkSendCommandEventsGroup >> gtItemsFor: aView [
	<gtView>
	
	^ aView columnedTree
		title: 'Events';
		priority: 10;
		items: [ self ];
		children: #subEvents;
		column: 'Event Type' text: [ :anEvent | anEvent class eventLabel ] width: 150;
		column: 'Timestamp' text: #timestamp;
		column: 'Command String' text: [ :anEvent | anEvent commandString ];
		column: 'Duration' 
			text: [ :anEvent | anEvent duration ] width: 150
]
