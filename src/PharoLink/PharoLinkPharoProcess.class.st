Class {
	#name : #PharoLinkPharoProcess,
	#superclass : #LanguageLinkAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables'
	],
	#classVars : [
		'NodejsPath',
		'PipenvPath'
	],
	#category : #'PharoLink-Pharo-Processes'
}

{ #category : #private }
PharoLinkPharoProcess class >> resolveServerExecutable [
	"Use the same executable as the receiver"

	^ FileLocator vmBinary resolve
]

{ #category : #accessing }
PharoLinkPharoProcess >> environmentVariables [
	"Answer the environment variables for the receiver.
	If the receiver's VM is being used, pass the environment varibales unchanged.
	If another executable is being used, remove the receiver's vm directory from LD_LIBRARY_PATH"

	^ environmentVariables ifNil: 
		[ environmentVariables := self settings serverExecutable = FileLocator vmBinary resolve
			ifTrue: [ Smalltalk os environment asDictionary ]
			ifFalse: [ self settings platform class subProcessEnvironmentDictionary ] ]
]

{ #category : #accessing }
PharoLinkPharoProcess >> errorMessage [
	^ process stderrStream contents
]

{ #category : #accessing }
PharoLinkPharoProcess >> exitCode [ 

	^ process exitCode
]

{ #category : #testing }
PharoLinkPharoProcess >> hasProcess [
	"Answer a boolean indicating whether the receiver has a process object"

	^ process isNotNil
]

{ #category : #testing }
PharoLinkPharoProcess >> isRunning [
	^ process
		ifNil: [ false ]
		ifNotNil: [ process isRunning ]
]

{ #category : #private }
PharoLinkPharoProcess >> newProcess [
	| newProcess |
	newProcess := GtUnixSubprocess new
				command: self settings serverExecutable fullName;
				arguments: self processArguments;
				workingDirectory: self workingDirectory resolve fullName;
				terminateOnShutdown;
				yourself.
	self environmentVariables associationsDo: [ :assoc |
		newProcess environmentAt: assoc key put: assoc value ].
	^ newProcess
]

{ #category : #accessing }
PharoLinkPharoProcess >> process [
	^ process
]

{ #category : #private }
PharoLinkPharoProcess >> processArguments [
	| args |

	args := OrderedCollection new.
	args 
		add: self settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkServer'.
	self debugMode ifTrue: [ args add: '--log' ].
	args
		add: self settings serverSocketAddress port asString;
		add: self settings clientSocketAddress port asString.
	^ args
]

{ #category : #accessing }
PharoLinkPharoProcess >> serverPath [

	^ self settings serverExecutable
]

{ #category : #'start-stop' }
PharoLinkPharoProcess >> start [

	self assert: process isNil.
	process := self newProcess.
	process run.
]

{ #category : #accessing }
PharoLinkPharoProcess >> stderr [

	^ process stderr
]

{ #category : #accessing }
PharoLinkPharoProcess >> stdout [ 

	^ process stdout
]

{ #category : #'start-stop' }
PharoLinkPharoProcess >> stop [
	process ifNil: [ ^ self ].
	[process queryExitStatus ifNil: [ process terminate ]] 
		on: Error 
		do: [ :e | "Do nothing."].
	process closeAndCleanStreams.
	"nil to allow restart"
	process := nil
]
