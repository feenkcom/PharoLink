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

	[ 
	announcer announce: aTestCase gtTestCaseStart.
	aTestCase runCaseManaged.
	announcer announce: aTestCase gtTestCasePass.
	self addPass: aTestCase ]
		on: self class failure , self class skip , self class warning
			, self class error
		do: [ :e | 
			e sunitAnnounce: aTestCase toResult: self.
			announcer announce: (e gtTestCaseException: aTestCase) ]
]
