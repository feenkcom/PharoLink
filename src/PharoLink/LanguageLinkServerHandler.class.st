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
	^ self stderr
]

{ #category : #accessing }
LanguageLinkServerHandler >> exitCode [

	^ process exitCode
]

{ #category : #accessing }
LanguageLinkServerHandler >> exitStatusInterpreter [

	^ process exitStatusInterpreter
]

{ #category : #testing }
LanguageLinkServerHandler >> hasProcess [
	"Answer a boolean indicating whether the is an external process object available"

	^ process hasProcess
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

{ #category : #accessing }
LanguageLinkServerHandler >> serverPath [
	"Answer the file reference to the server's executable"

	^ process serverPath
]

{ #category : #testing }
LanguageLinkServerHandler >> start [
	self platform ensureEnvironmentForApp: self application.
	^ process start
]

{ #category : #accessing }
LanguageLinkServerHandler >> stderr [

	^ process stderr
]

{ #category : #accessing }
LanguageLinkServerHandler >> stdout [

	^ process stdout
]

{ #category : #testing }
LanguageLinkServerHandler >> stop [
	^ process stop
]
