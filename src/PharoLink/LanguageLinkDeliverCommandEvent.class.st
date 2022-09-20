Class {
	#name : #LanguageLinkDeliverCommandEvent,
	#superclass : #LanguageLinkCommandEvent,
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkDeliverCommandEvent class >> eventLabel [
	^ 'Deliver Command'
]

{ #category : #accessing }
LanguageLinkDeliverCommandEvent >> commandString [ 
	^ self signalStartedEvent commandString
]

{ #category : #'gt - extensions' }
LanguageLinkDeliverCommandEvent >> gtViewCommandStringFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Command String';
		priority: 5;
		object: [ self signalCompletedEvent ];
		view: #gtViewCommandStringFor:
]
