Class {
	#name : #PharoLinkRequestSignal,
	#superclass : #PharoLinkSignal,
	#instVars : [
		'request'
	],
	#category : 'PharoLink-Logging'
}

{ #category : #printing }
PharoLinkRequestSignal >> printOn: stream [ 

	stream 
		nextPutAll: self timestamp asString;
		space;
		nextPutAll: self class name;
		space.

	request ifNil: [ ^stream << '<no request>' ].

	stream cr.
	request keysAndValuesDo: [ :key :value |
		stream
			tab;
			<< key;
			<< ': ';
			print: value;
			cr ].
]

{ #category : #printing }
PharoLinkRequestSignal >> printOneLineContentsOn: stream [ 

	request ifNil: [ ^ self printOn: stream ].
	
	stream
		<< 'Request: ';
		<< (request at: #type)
]

{ #category : #accessing }
PharoLinkRequestSignal >> request [
	<return: #Dictionary>

	^ request
]

{ #category : #accessing }
PharoLinkRequestSignal >> request: anObject [
	request := anObject
]
