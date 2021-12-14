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
	taskQueue := PharoLinkWorkerTaskQueue new
]

{ #category : #accessing }
PharoLinkWorkerServer >> newConnection: aSocket [

	^ PharoLinkWorkerServerConnection
		  server: self
		  socket: aSocket
		  taskQueue: taskQueue
]

{ #category : #accessing }
PharoLinkWorkerServer >> nextPut: aTask [

	^ taskQueue nextPut: aTask
]
