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
	| start resourceStart resourceEnd announcement |

	start := aTestCase gtTestCaseStart.
	announcer announce: start.
	resourceStart := GtVmRuntimeStatisticsReport new recordReportStatistics.
	[ "Force the test case to be run under the control of the execution environment.
	This should force timeouts for alternate test frameworks
	aTestCase runCaseManaged."
	CurrentExecutionEnvironment runTestCase: aTestCase.

	resourceEnd := GtVmRuntimeStatisticsReport new recordReportStatistics.
	announcement := aTestCase gtTestCasePassStartTimestamp: start timestamp.
	announcement resourceReport: (GtVmRuntimeStatisticsDiffReport new
		sourceReport: resourceStart;
		targetReport: resourceEnd;
		yourself).
	announcer announce: announcement.
	self addPass: aTestCase ]
		on: self class failure , self class skip , self class warning
			, self class error
		do: [ :e | 
			resourceEnd := GtVmRuntimeStatisticsReport new recordReportStatistics.
			e sunitAnnounce: aTestCase toResult: self.
			announcement := e gtTestCaseException: aTestCase startTimestamp: start timestamp.
			announcement resourceReport: (GtVmRuntimeStatisticsDiffReport new
				sourceReport: resourceStart;
				targetReport: resourceEnd;
				yourself).
			announcer announce: announcement ].
]
