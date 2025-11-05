Class {
	#name : #LanguageLinkCommandEvent,
	#superclass : #GtBeaconLogEvent,
	#category : 'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkCommandEvent >> commandString [ 
	^ self eventStartedSignal commandString
]

{ #category : #'gt - extensions' }
LanguageLinkCommandEvent >> gtViewCommandStringFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Command string';
		priority: 5;
		object: [ self eventCompletedSignal ];
		view: #gtViewCommandStringFor:
]

{ #category : #accessing }
LanguageLinkCommandEvent >> processId [
	^ self eventStartedSignal processId
]

{ #category : #accessing }
LanguageLinkCommandEvent >> remoteReceiverDescription [
	^ self eventStartedSignal remoteReceiverDescription
]

{ #category : #accessing }
LanguageLinkCommandEvent >> remoteReceiverIdentityHash [
	^ self eventStartedSignal remoteReceiverIdentityHash
]
