Class {
	#name : 'PharoLinkResponseSignal',
	#superclass : 'BeaconSignal',
	#instVars : [
		'response'
	],
	#category : 'PharoLink-Logging'
}

{ #category : 'printing' }
PharoLinkResponseSignal >> printOn: stream [ 

	stream 
		nextPutAll: self timestamp asString;
		space;
		nextPutAll: self class name;
		space.

	response ifNil: [ ^stream << '<no response>' ].

	stream cr.
	response keysAndValuesDo: [ :key :value |
		stream
			tab;
			<< key;
			<< ': ';
			print: value;
			cr ].
]

{ #category : 'printing' }
PharoLinkResponseSignal >> printOneLineContentsOn: stream [ 

	response ifNil: [ ^ self printOn: stream ].
	
	stream
		<< 'Response: ';
		<< (response at: #type)
]

{ #category : 'accessing' }
PharoLinkResponseSignal >> response [
	<return: #Dictionary>
	
	^ response
]

{ #category : 'accessing' }
PharoLinkResponseSignal >> response: anObject [
	response := anObject
]
