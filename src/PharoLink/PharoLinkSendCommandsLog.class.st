Class {
	#name : #PharoLinkSendCommandsLog,
	#superclass : #Object,
	#traits : 'TGtGroup + TGtGroupItems',
	#classTraits : 'TGtGroup classTrait + TGtGroupItems classTrait',
	#category : #'PharoLink-Logs'
}

{ #category : #accessing }
PharoLinkSendCommandsLog >> gtCommandsDetailedFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Commands';
		items: [ self ];
		column: 'Timestamp' text: [ :each | each timestamp ] width: 250;
		column: 'Process' text: [ :each | each processId ] width: 200;
		column: 'Receiver' text: [ :each | 
			each remoteReceiverDescription ];
		column: 'Action' text: [ :each | each extractSelector ];
		column: 'Serialized' text: [ :each | each isSerializedCall 
			ifTrue: [ 'yes' ] 
			ifFalse: [ '' ]  ] width: 100
		"column: 'Request Size' text: [ :each | '-' ] width: 100;
		column: 'Respons Size' text: [ :each | '-' ]  width: 100;
		column: 'Total Duration' text: [ :each | '-' ]  width: 100"
]

{ #category : #accessing }
PharoLinkSendCommandsLog >> gtItemsFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Commands (basic)';
		items: [ self ];
		column: 'Timestamp' text: [ :each | each timestamp ] width: 250;
		column: 'Command' text: [ :each | each command ]
	
]
