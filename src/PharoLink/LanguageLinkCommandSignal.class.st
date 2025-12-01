Class {
	#name : #LanguageLinkCommandSignal,
	#superclass : #LanguageLinkSignal,
	#instVars : [
		'eventType'
	],
	#category : 'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkCommandSignal >> bindingsDictionary [
	self subclassResponsibility 
]

{ #category : #'gt - extensions' }
LanguageLinkCommandSignal >> gtViewBindingsFor: aView [
	<gtView>
	
	self bindingsDictionary ifNil: [
		^ aView empty ].
	
	^ aView forward
		title: 'Bindings';
		priority: 25;
		object: [ self bindingsDictionary ];
		view: #gtItemsFor:
]

{ #category : #'gt - extensions' }
LanguageLinkCommandSignal >> gtViewCommandStringFor: aView [
	<gtView>
	
	self hasCommandString ifNil: [
		^ aView empty ].
	
	^ aView textEditor
		title: 'Command string' translated;
		priority: 14;
		text: [ self commandString ];
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new
				   isForWorkspace: true;
				   yourself)
]

{ #category : #accessing }
LanguageLinkCommandSignal >> hasCommandString [
	self subclassResponsibility
]

{ #category : #testing }
LanguageLinkCommandSignal >> isEndSignalType [
	^ eventType = #endSignal
]

{ #category : #testing }
LanguageLinkCommandSignal >> isStartSignalType [
	^ eventType = #startSignal
]

{ #category : #initialization }
LanguageLinkCommandSignal >> markAsEndSignal [
	eventType := #endSignal
]

{ #category : #initialization }
LanguageLinkCommandSignal >> markAsStartSignal [
	eventType := #startSignal
]

{ #category : #accessing }
LanguageLinkCommandSignal >> remoteReceiverDescription [
	^ self bindingsDictionary
		at: 'self' 
		ifPresent: [ :anObject | 
			
				'a '
				,anObject remoteClass asString
				, ' (' 
				, anObject name
				, ') ['
				, anObject identityHash asString
				, ']' ]
		ifAbsent: [nil]
]

{ #category : #accessing }
LanguageLinkCommandSignal >> remoteReceiverIdentityHash [
	^ self bindingsDictionary 
		at: 'self' 
		ifPresent: [ :anObject | anObject identityHash ]
		ifAbsent: [ nil ]
]
