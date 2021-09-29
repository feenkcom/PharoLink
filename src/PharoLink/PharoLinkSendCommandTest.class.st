Class {
	#name : 'PharoLinkSendCommandTest',
	#superclass : 'PharoLinkApplicationTest',
	#category : 'PharoLink-Tests'
}

{ #category : 'tests' }
PharoLinkSendCommandTest >> testAddBinding [
	| array binding result |

	array := #((2) 3).
	binding := PharoLinkBinding wrap: array.
	result := application newCommandFactory
		addBinding: binding;
		<< binding;
		sendAndWait.
	self assert: result equals: #((2) 3)
]

{ #category : 'tests' }
PharoLinkSendCommandTest >> testAddObserver [
	| cf observer callbackExecuted promiseSem promise |

	promiseSem := Semaphore new.
	callbackExecuted := false.
	cf := application newCommandFactory.
	observer := cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true ].
	cf << (observer notifyWith: 33).
	cf << '2'.
	promise := cf send.
	promiseSem signal.
	self assert: promise waitForValue equals: 2.
	self assert: callbackExecuted
]

{ #category : 'tests' }
PharoLinkSendCommandTest >> testCallbackReturnValue [
	| cf observer callbackExecuted promiseSem promise |

	promiseSem := Semaphore new.
	callbackExecuted := false.
	cf := application newCommandFactory.
	observer := cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self assert: promise isSignaled not.
		callbackExecuted := true.
		5 ].
	cf << (observer notifyWith: 33).
	promise := cf send.
	promiseSem signal.
	self assert: promise waitForValue equals: 5.
	self assert: callbackExecuted.

]

{ #category : 'tests' }
PharoLinkSendCommandTest >> testInvalidCallbackReturn [
	| cf observer callbackExecuted promiseSem promise |

	promiseSem := Semaphore new.
	callbackExecuted := false.
	cf := application newCommandFactory.
	observer := cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true.
		self ].
	cf << (observer notifyWith: 33).
	promise := cf send.
	promiseSem signal.
	self assert: promise waitForValue equals: nil.
	self assert: callbackExecuted
]

{ #category : 'tests' }
PharoLinkSendCommandTest >> testSendAssignAsLastMessage [
	| meaning |

	meaning := application newCommandFactory
		<< '| a | a := 42';
		sendAndWait.
	self assert: meaning equals: 42
]
