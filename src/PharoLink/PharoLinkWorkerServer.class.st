Class {
	#name : #PharoLinkWorkerServer,
	#superclass : #PharoLinkServer,
	#instVars : [
		'taskQueue'
	],
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorkerServer class >> port: anInteger [

	^ self new
		  listenPort: anInteger;
		  setDebugMode;
		  yourself
]

{ #category : #accessing }
PharoLinkWorkerServer >> connections [

	^ connections
]

{ #category : #accessing }
PharoLinkWorkerServer >> initialize [

	super initialize.
	taskQueue := PharoLinkWorkerTaskQueue new.
	globals at: #taskQueue put: taskQueue
]

{ #category : #accessing }
PharoLinkWorkerServer >> newConnection: aSocket [

	^ PharoLinkWorkerServerConnection server: self socket: aSocket
]

{ #category : #accessing }
PharoLinkWorkerServer >> nextPut: aTask [

	^ taskQueue nextPut: aTask
]
