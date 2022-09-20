Class {
	#name : #LanguageLinkSendCommandEvent,
	#superclass : #LanguageLinkCommandEvent,
	#category : #'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkSendCommandEvent class >> eventLabel [
	^ 'Send Command'
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> codeForRemote [ 
	^ self subEvents first commandString
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> commandString [ 
	^ self signalStartedEvent commandString
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> gtViewCommandStringFor: aView [
	<gtView>
	
	^ aView forward 
		title: 'Command String';
		priority: 5;
		object: [ self signalCompletedEvent ];
		view: #gtViewCommandStringFor:
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> gtViewRemoteCodeFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'Remote Code';
		priority: 10;
		text: [ self codeForRemote ];
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new
				   isForWorkspace: true;
				   yourself)
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> processId [
	^ self signalStartedEvent processId
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> remoteReceiverDescription [
	^ self signalStartedEvent remoteReceiverDescription
]

{ #category : #accessing }
LanguageLinkSendCommandEvent >> remoteReceiverIdentityHash [
	^ self signalStartedEvent remoteReceiverIdentityHash
]
