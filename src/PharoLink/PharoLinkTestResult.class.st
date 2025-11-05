"
PharoLinkTestResult extends the test execution capabilities of TestResult to:

- record detailed execution and resource usage information.
- be able to set a debug flag allowing a suite of tests to be run using the standard call sequence.
"
Class {
	#name : #PharoLinkTestResult,
	#superclass : #TestResult,
	#instVars : [
		'announcer',
		'debugMode'
	],
	#category : 'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestResult >> announcer [

	^ announcer
]

{ #category : #accessing }
PharoLinkTestResult >> debugMode [

	^ debugMode
]

{ #category : #accessing }
PharoLinkTestResult >> debugMode: anObject [

	debugMode := anObject
]

{ #category : #accessing }
PharoLinkTestResult >> initialize [

	super initialize.
	announcer := Announcer new.
	debugMode := false.
]

{ #category : #accessing }
PharoLinkTestResult >> runCase: aTestCase [
	| start resourceReport |

	start := aTestCase gtTestCaseStart.
	announcer announce: start.
	resourceReport := GtRrCheckResourcesReport new.
	resourceReport recordSourceReport.
	
	debugMode
		ifTrue: [ self runCaseDebug: aTestCase start: start report: resourceReport ]
		ifFalse: [ self runCaseNoDebug: aTestCase start: start report: resourceReport ]
]

{ #category : #accessing }
PharoLinkTestResult >> runCaseDebug: aTestCase start: start report: resourceReport [
	| announcement |

	CurrentExecutionEnvironment runTestCase: aTestCase.

	resourceReport recordTargetReport.
	announcement := aTestCase gtTestCasePassStartTimestamp: start timestamp.
	announcement resourceReport: resourceReport.
	announcer announce: announcement.
	self addPass: aTestCase.
]

{ #category : #accessing }
PharoLinkTestResult >> runCaseNoDebug: aTestCase start: start report: resourceReport [
	[self runCaseDebug: aTestCase start: start report: resourceReport]
		on: self class failure , self class skip , self class warning
				, self class error
		do: 
			[:e |
			| announcement |
			resourceReport recordTargetReport.
			e sunitAnnounce: aTestCase toResult: self.
			announcement := e
						gtTestCaseException: aTestCase
						startTimestamp: start timestamp
						additionalData: e pharoLinkAdditionalData.
			announcement resourceReport: resourceReport.
			announcer announce: announcement]
]

{ #category : #accessing }
PharoLinkTestResult >> setDebugMode [

	debugMode := true
]
