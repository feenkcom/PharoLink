Class {
	#name : #PharoLinkWorkerExamples,
	#superclass : #Object,
	#instVars : [
		'service',
		'server'
	],
	#category : #'PharoLink-Examples'
}

{ #category : #accessing }
PharoLinkWorkerExamples >> ping [

	<gtExample>
	<after: #stop>
	| connection before after |
	self start.
	service addObserver.
	self waitForObservers.
	connection := server connections first.
	self assert: [ connection lastPing isNil ].
	before := DateAndTime now.
	connection ping.
	after := DateAndTime now.
	self assert: [ connection lastPing between: before and: after ].
	^ connection
]

{ #category : #accessing }
PharoLinkWorkerExamples >> start [

	<gtExample>
	server := PharoLinkWorkerServer port: 8442.
	service := PharoLinkWorkerService serverSocketAddress: 8442 asString.
	server start.
	service start.
	^ { 
		  server.
		  service }
]

{ #category : #accessing }
PharoLinkWorkerExamples >> stop [

	<gtExample>
	service stop.
	server stop.
	^ { 
		  service.
		  server }
]

{ #category : #accessing }
PharoLinkWorkerExamples >> waitForObservers [

	| waited |
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
