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
