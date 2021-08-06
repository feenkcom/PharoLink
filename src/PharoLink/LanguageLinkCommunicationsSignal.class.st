Class {
	#name : 'LanguageLinkCommunicationsSignal',
	#superclass : 'BeaconSignal',
	#instVars : [
		'originalException',
		'commandId',
		'stackString'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : 'accessing' }
LanguageLinkCommunicationsSignal >> commandId [

	^ commandId
]

{ #category : 'accessing' }
LanguageLinkCommunicationsSignal >> commandId: anObject [

	commandId := anObject
]

{ #category : 'accessing' }
LanguageLinkCommunicationsSignal >> originalException [

	^ originalException
]

{ #category : 'accessing' }
LanguageLinkCommunicationsSignal >> originalException: anObject [

	originalException := anObject
]

{ #category : 'printing' }
LanguageLinkCommunicationsSignal >> printOneLineContentsOn: stream [

	stream 
		<< 'id: ';
		print: commandId;
		<< ': ';
		print: originalException
]

{ #category : 'accessing' }
LanguageLinkCommunicationsSignal >> stackString [

	^ stackString
]

{ #category : 'accessing' }
LanguageLinkCommunicationsSignal >> stackString: anObject [

	stackString := anObject
]
