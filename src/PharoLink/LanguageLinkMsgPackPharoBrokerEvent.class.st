Class {
	#name : #LanguageLinkMsgPackPharoBrokerEvent,
	#superclass : #GtBeaconLogEvent,
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkMsgPackPharoBrokerEvent class >> eventLabel [
	^ 'Broker Message Event'
]

{ #category : #'gt - extensions' }
LanguageLinkMsgPackPharoBrokerEvent >> gtDetailsIn: composite [
	<gtView>
	^ composite forward
		title: 'Details';
		priority: 5;
		object: [ self eventStartedSignal ];
		view: #gtDetailsIn:
]
