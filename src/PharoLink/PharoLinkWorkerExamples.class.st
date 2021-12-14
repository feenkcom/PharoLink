Class {
	#name : #PharoLinkWorkerExamples,
	#superclass : #Object,
	#instVars : [
		'service',
		'server',
		'connection'
	],
	#category : #'PharoLink-Examples'
}

{ #category : #accessing }
PharoLinkWorkerExamples >> assert: aBlock signals: aClass [

	| signaled |
	signaled := false.
	aBlock
		on: aClass
		do: [ signaled := true ].
	self
		assert: signaled
		description:
		('Expected {1} to be signaled, but was not' format: { aClass })
]

{ #category : #accessing }
PharoLinkWorkerExamples >> commandPing [

	<gtExample>
	<after: #stop>
	| before after |
	self start.
	self waitForObservers.
	"should just not fail"
	connection commandPing.
	^ connection
]

{ #category : #accessing }
PharoLinkWorkerExamples >> commandTerminateCurrentTask [

	<gtExample>
	<after: #stop>
	| task promise done success result |
	self start.
	self waitForObservers.
	self assert: [ connection currentTask isNil ].
	done := Semaphore new.
	(server nextPut: PharoLinkWorkerWaitTask new)
		then: [ :e | 
			success := true.
			result := e.
			done signal ]
		otherwise: [ :e | 
			success := false.
			result := e.
			done signal ].
	self waitForCurrentTask: connection.
	self assert: [ connection currentTask isNotNil ].
	self assert: [ connection commandTerminateCurrentTask ].
	done wait.
	self assert: [ success not ].
	self assert: [ result beginsWith: 'PharoLinkWorkerTaskError' ].
	self assert: [ connection currentTask isNil ].
	self assert: [ connection commandTerminateCurrentTask not ].
	^ connection
]

{ #category : #accessing }
PharoLinkWorkerExamples >> start [

	<gtExample>
	<after: #stop>
	server := PharoLinkWorkerServer port: 8442.
	service := PharoLinkWorkerService serverSocketAddress: 8442 asString.
	server start.
	service start.
	connection := server connections first.
	^ { 
		  server.
		  service.
		  connection }
]

{ #category : #accessing }
PharoLinkWorkerExamples >> stop [

	<gtExample>
	connection ifNotNil: #stop.
	service ifNotNil: #kill.
	server ifNotNil: #stop.
	^ { 
		  connection.
		  service.
		  server }
]

{ #category : #accessing }
PharoLinkWorkerExamples >> waitForCurrentTask: aConnection [

	| waited |
	waited := 0.
	[ aConnection currentTask isNil ] whileTrue: [ 
		waited > 2000 ifTrue: [ 
			self error:
				'waited for two seconds, current task is nil' ].
		100 milliSeconds wait.
		waited := waited + 100 ]
]

{ #category : #accessing }
PharoLinkWorkerExamples >> waitForObservers [

	| waited |
	service addObserver.
	waited := 0.
	[ 
	server connections isEmpty or: [ 
		server connections anySatisfy: [ :e | e hasObserver not ] ] ] 
		whileTrue: [ 
			waited > 2000 ifTrue: [ 
				self error:
					'waited for two seconds, not all connections have observers' ].
			100 milliSeconds wait.
			waited := waited + 100 ]
]
