Class {
	#name : #LanguageLinkAbstractProcess,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#classInstVars : [
		'serverExecutable'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #accessing }
LanguageLinkAbstractProcess class >> application: application [
	^ self new
		application: application;
		yourself
]

{ #category : #private }
LanguageLinkAbstractProcess class >> resolveServerExecutable [

	^ self subclassResponsibility 
]

{ #category : #accessing }
LanguageLinkAbstractProcess class >> serverExecutable [ 

	^ serverExecutable ifNil: [ serverExecutable := self resolveServerExecutable ]
]

{ #category : #initialization }
LanguageLinkAbstractProcess class >> signalCommandNotFound: commandString [
	"JSLink use the unix command `which` to find the full path of the supplied command. From Pharo
	we could not find the path, therefore you have to set it mannualy.
		
	To find the path of a command in your system run the command `which <command>` in the terminal.
	To set the path in PythonBridge send the following message:
	
	JSLinkPharoNodejsProcess nodeJSPath: '/path/to/nodejs'.
	JSLinkPharoNodejsProcess npmPath: '/path/to/npm'."

	Error signal: 'Error: ', commandString, ' command could not be found.'
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> application: anObject [
	application := anObject
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> applicationReady [
	"A notification sent by our application when startup has completed successfully"
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> debugMode [

	^ self settings debugMode
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> errorMessage [
	self subclassResponsibility
]

{ #category : #testing }
LanguageLinkAbstractProcess >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> settings [
	^ self application settings
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> startServerDebugger [
	"Perform any initialisation necessary when running the server with debug mode enabled.
	By default there's nothing to do.  Subclasses should override this as required (typically in an extension method associated with the debugger)"
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> stderr [
	"Answer stderr of the process.
	Subclasses that can provide stdout out should overwrite this method"

	^ '<unavailable>'
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> stdout [ 
	"Answer stdout of the process.
	Subclasses that can provide stdout out should overwrite this method"

	^ '<unavailable>'
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> stop [
	self subclassResponsibility
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> stopServerDebugger [
	"Perform any shutdown necessary when running the server with debug mode enabled.
	By default there's nothing to do.  Subclasses should override this as required (typically in an extension method associated with the debugger)"
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> workingDirectory [
	^ application settings workingDirectory
]
