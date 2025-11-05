Class {
	#name : #PharoLinkSerializationTest,
	#superclass : #PharoLinkApplicationTest,
	#category : 'PharoLink-Tests'
}

{ #category : #tests }
PharoLinkSerializationTest >> testSendAndRetrieveArray [
	| value |

	"Arrays are answered by proxy by default."
	value := application newCommandFactory
		<< '{ 1. true. nil }';
		sendAndWait.
	self assert: (value isKindOf: PharoLinkProxyObject).

	"Answer by value"
	value := application newCommandFactory
		setByValue;
		<< '{ 1. true. nil }.';
		sendAndWait.
	self assert: value equals: #(1 true nil).

	"Raise an exception if requiring primitives only and it fails"
	self should:
			[ application newCommandFactory
				setByValueOnly;
				<< '{ 1. true. Object new. }.';
				sendAndWait ]
		raise: PharoLinkRemoteError.

]

{ #category : #tests }
PharoLinkSerializationTest >> testSendAndRetrieveDateAndTime [
	| value |

	"DateAndTimes are answered by proxy by default."
	value := application newCommandFactory
		<< 'DateAndTime now.';
		sendAndWait.
	self assert: (value isKindOf: PharoLinkProxyObject).

	"Answer serialized"
	value := application newCommandFactory
		setBySerialized;
		<< 'DateAndTime now.';
		sendAndWait.
	self assert: value class equals: DateAndTime.

	^ value
]

{ #category : #tests }
PharoLinkSerializationTest >> testSendAndRetrieveDictionary [
	| value |

	"Dictionaries are answered by proxy by default."
	value := application newCommandFactory
		<< '{ 1 -> true. 2 -> nil } asDictionary';
		sendAndWait.
	self assert: (value isKindOf: PharoLinkProxyObject).

	"Answer by value"
	value := application newCommandFactory
		setByValue;
		<< '{ 1 -> true. 2 -> nil } asDictionary.';
		sendAndWait.
	self assert: (value sameContentAs: { 1 -> true. 2 -> nil } asDictionary).

	"Raise an exception if requiring primitives only and it fails"
	self should:
			[ application newCommandFactory
				setByValueOnly;
				<< '{ 1 -> true. 2 -> Object new. } asDictionary.';
				sendAndWait ]
		raise: PharoLinkRemoteError.

]

{ #category : #tests }
PharoLinkSerializationTest >> testSendAndRetrieveFloat [
	| value |

	value := application newCommandFactory
		<< 2.2;
		sendAndWait.
	self assert: value equals: 2.2.
]

{ #category : #tests }
PharoLinkSerializationTest >> testSendAndRetrieveInteger [
	| value |

	value := application newCommandFactory
		<< 2;
		sendAndWait.
	self assert: value equals: 2.
]

{ #category : #tests }
PharoLinkSerializationTest >> testSendAndRetrieveNil [
	| value |

	value := application newCommandFactory
		<< nil;
		sendAndWait.
	self assert: value equals: nil.
]
