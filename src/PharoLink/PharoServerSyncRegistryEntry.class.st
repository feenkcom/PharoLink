"
A PharoServerSyncRegistryEntry is created for every synchronous message sent by the server back to the client.  Currently this is only for observer callbacks.

The eval command process waits on the semaphore for the result to be stored.  Once the semaphore is signalled, the eval command continues.
"
Class {
	#name : #PharoServerSyncRegistryEntry,
	#superclass : #Object,
	#instVars : [
		'id',
		'semaphore',
		'result',
		'exception'
	],
	#category : #'PharoLink-Server'
}

{ #category : #accessing }
PharoServerSyncRegistryEntry class >> id: aString [

	^ self new id: aString
]

{ #category : #accessing }
PharoServerSyncRegistryEntry >> id [

	^ id
]

{ #category : #accessing }
PharoServerSyncRegistryEntry >> id: anObject [

	id := anObject
]

{ #category : #initialization }
PharoServerSyncRegistryEntry >> initialize [ 

	super initialize.
	semaphore := Semaphore new.
]

{ #category : #accessing }
PharoServerSyncRegistryEntry >> result [

	^ result
]

{ #category : #accessing }
PharoServerSyncRegistryEntry >> result: anObject [

	result := anObject
]

{ #category : #signalling }
PharoServerSyncRegistryEntry >> signal [

	semaphore signal
]

{ #category : #signalling }
PharoServerSyncRegistryEntry >> signalConnectionLost [

	exception := PharoLinkServerConnectionLost new.
	self signal.
]

{ #category : #waiting }
PharoServerSyncRegistryEntry >> wait [

	semaphore wait.
	exception ifNotNil: [ exception signal ].
]
