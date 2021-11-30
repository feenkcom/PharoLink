Class {
	#name : #PharoLinkWorkerTestTask,
	#superclass : #PharoLinkWorkerTask,
	#instVars : [
		'tests'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerTestTask class >> leJsonV4Name [

	^ #pharoLinkWorkerTestTask
]

{ #category : #accessing }
PharoLinkWorkerTestTask class >> tests: aDictionary [

	^ self new
		  tests: aDictionary;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerTestTask >> run [

	| suite result events |
	suite := TestSuite named: id.
	tests keysAndValuesDo: [ :className :selectors | 
		| class |
		class := className asClass.
		suite addTests: (class buildSuiteFromMethods: selectors) tests ].
	events := OrderedCollection new.
	result := PharoLinkTestResult new.
	result announcer
		when: PharoLinkTestCaseEndAnnouncement
		do: [ :e | events add: e ].
	suite run: result.
	^ events asArray
]

{ #category : #accessing }
PharoLinkWorkerTestTask >> tests [

	^ tests
]

{ #category : #accessing }
PharoLinkWorkerTestTask >> tests: aDictionary [

	tests := aDictionary
]
