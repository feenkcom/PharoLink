Class {
	#name : #PharoLinkPromiseRegistryTest,
	#superclass : #TestCase,
	#instVars : [
		'registry'
	],
	#category : 'PharoLink-Tests'
}

{ #category : #initialization }
PharoLinkPromiseRegistryTest >> setUp [
	registry := LanguageLinkPromiseRegistry new
]

{ #category : #initialization }
PharoLinkPromiseRegistryTest >> testAddPromise [
	registry addPromise: (LanguageLinkPromise id: '123').
	self assert: registry promiseTable size equals: 1.
	self assert: registry promiseTable anyOne proxyObjectId equals: '123'
]

{ #category : #initialization }
PharoLinkPromiseRegistryTest >> testRemovePromiseId [
	registry addPromise: (LanguageLinkPromise id: '123').
	registry removePromiseId: '123'.
	self assert: registry promiseTable size equals: 0
]

{ #category : #initialization }
PharoLinkPromiseRegistryTest >> testSignalPromise [
	| semaphore flag promise |
	semaphore := Semaphore new.
	flag := false.
	promise := (LanguageLinkPromise id: '123').
	registry addPromise: promise.
	[ 	
		self assert: promise waitForValue equals: #foo.
		flag := true.
		semaphore signal. ] fork.
	registry signalPromiseId: '123' with: #foo.
	semaphore wait.
	self assert: flag
]

{ #category : #initialization }
PharoLinkPromiseRegistryTest >> testSignalPromiseWithTransformBlock [
	| semaphore flag promise |
	semaphore := Semaphore new.
	flag := false.
	promise := (LanguageLinkPromise id: '123')
						transformBlock: [ :obj | 55 ].
	registry addPromise: promise.
	[ 	
		self assert: promise waitForValue equals: 55.
		flag := true.
		semaphore signal. ] fork.
	registry signalPromiseId: '123' with: #foo.
	semaphore wait.
	self assert: flag
]
