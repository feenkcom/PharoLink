Class {
	#name : #LanguageLinkMsgPackPharoBrokerSignal,
	#superclass : #LanguageLinkSignal,
	#traits : 'TGtBeaconSignalStartEndType',
	#classTraits : 'TGtBeaconSignalStartEndType classTrait',
	#instVars : [
		'message'
	],
	#category : #'PharoLink-Logging'
}

{ #category : #'gt extensions' }
LanguageLinkMsgPackPharoBrokerSignal >> gtDetails [
	^ {
		{ 'Timestamp' . self timestamp }.
		{ 'Process' . self processId }.
		{ 'Type' . self class }.
		{ 'EventType' . eventType }.
		{ 'MessageType' . self message at: #type ifAbsent: [ '' ] }.
	}
]

{ #category : #'gt extensions' }
LanguageLinkMsgPackPharoBrokerSignal >> gtDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		priority: 10;
		items: [ self gtDetails ];
		column: #key text: #first weight: 0.25;
		column: #value text: #second;
		send: #last
]

{ #category : #accessing }
LanguageLinkMsgPackPharoBrokerSignal >> message [
	^ message
]

{ #category : #accessing }
LanguageLinkMsgPackPharoBrokerSignal >> message: anObject [
	message := anObject
]
