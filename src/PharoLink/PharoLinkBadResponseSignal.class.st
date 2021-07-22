Class {
	#name : #PharoLinkBadResponseSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'request',
		'response'
	],
	#category : 'PharoLink-Logging'
}

{ #category : #'instance creation' }
PharoLinkBadResponseSignal class >> emitRequest: request response: response [

	^ self new
		request: request;
		response: response;
		emit
]

{ #category : #printing }
PharoLinkBadResponseSignal >> printOneLineContentsOn: stream [

	stream 
		<< 'id: ';
		<< (request at: 'id' ifAbsent: [ '<unknown>' ]);
		<< ', status: ';
		print: response status.
]

{ #category : #accessing }
PharoLinkBadResponseSignal >> request [
	^ request
]

{ #category : #accessing }
PharoLinkBadResponseSignal >> request: anObject [
	request := anObject
]

{ #category : #accessing }
PharoLinkBadResponseSignal >> response [
	^ response
]

{ #category : #accessing }
PharoLinkBadResponseSignal >> response: anObject [
	response := anObject
]
