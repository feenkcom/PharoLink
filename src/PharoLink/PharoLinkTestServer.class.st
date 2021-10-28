Class {
	#name : #PharoLinkTestServer,
	#superclass : #Object,
	#instVars : [
		'suite',
		'result',
		'notifier'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestServer class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #accessing }
PharoLinkTestServer class >> reset [

	instance := nil
]

{ #category : #accessing }
PharoLinkTestServer >> run: aSuite notifier: aBlock [

	| events pusher finished semaphore subscription |
	suite := aSuite.
	notifier := aBlock.
	result := PharoLinkTestResult new.
	events := AtomicSharedQueue new.
	semaphore := Semaphore new.
	finished := false.
	pusher := [ 
	          [ finished and: [ events isEmpty ] ] whileFalse: [ 
		          | buffer |
		          500 milliSeconds wait.
		          buffer := OrderedCollection new.
		          events flush: [ :e | buffer add: e ].
		          buffer ifNotEmpty: [ 
			          notifier value: (LanguageLinkUtils base64Encode: buffer) ] ].
	          semaphore signal ] fork.
	subscription := result announcer
		                when: PharoLinkTestAnnouncement
		                do: [ :e | events nextPut: e ].
	[ suite run: result ] ensure: [ 
		finished := true.
		semaphore wait.
		result announcer unsubscribe: subscription ].
	^ result
]
