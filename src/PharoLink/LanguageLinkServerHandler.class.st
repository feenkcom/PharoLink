"
LanguageLinkServerHandler is responsible for setting up and running the remote server.
 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	process:		<Object>


    Implementation Points
"
Class {
	#name : #LanguageLinkServerHandler,
	#superclass : #LanguageLinkHandler,
	#instVars : [
		'process'
	],
	#category : #'PharoLink-Core'
}

{ #category : #accessing }
LanguageLinkServerHandler >> errorMessage [
	^ process errorMessage
]

{ #category : #initialization }
LanguageLinkServerHandler >> initializeHandler [
	super initializeHandler.
	process := self application settings serverProcessClass application: self application.
]

{ #category : #testing }
LanguageLinkServerHandler >> isRunning [
	^ process isRunning
]

{ #category : #accessing }
LanguageLinkServerHandler >> platform [

	^ self application settings platform
]

{ #category : #testing }
LanguageLinkServerHandler >> start [
	self platform ensureEnvironmentForApp: self application.
	^ process start
]

{ #category : #testing }
LanguageLinkServerHandler >> stop [
	^ process stop
]
