Class {
	#name : #PharoLinkSerializationTest,
	#superclass : #PharoLinkApplicationTest,
	#category : 'PharoLink-Tests'
}

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
