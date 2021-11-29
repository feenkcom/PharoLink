Class {
	#name : #PharoLinkTestResult,
	#superclass : #TestResult,
	#instVars : [
		'announcer'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestResult >> announcer [

	^ announcer
]

{ #category : #accessing }
PharoLinkTestResult >> initialize [

	super initialize.
	announcer := Announcer new
]

{ #category : #accessing }
PharoLinkTestResult >> runCase: aTestCase [

	| start |
	start := aTestCase gtTestCaseStart.
	announcer announce: start.
	[ "Force the test case to be run under the control of the execution environment.
	This should force timeouts for alternate test frameworks
	aTestCase runCaseManaged."
	CurrentExecutionEnvironment runTestCase: aTestCase.

	announcer announce:
		(aTestCase gtTestCasePassStartTimestamp: start timestamp).
	self addPass: aTestCase ]
		on: self class failure , self class skip , self class warning
			, self class error
		do: [ :e | 
			e sunitAnnounce: aTestCase toResult: self.
			announcer announce:
				(e gtTestCaseException: aTestCase startTimestamp: start timestamp) ]
]
