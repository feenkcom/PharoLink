Class {
	#name : #LanguageLinkManualProcess,
	#superclass : #LanguageLinkAbstractProcess,
	#category : 'PharoLink-Pharo-Processes'
}

{ #category : #private }
LanguageLinkManualProcess class >> resolveServerExecutable [

	^ self shouldNotImplement 
]

{ #category : #accessing }
LanguageLinkManualProcess class >> workingDirectory [
	^ FileLocator workingDirectory
]

{ #category : #accessing }
LanguageLinkManualProcess >> errorMessage [

	^ '<see manually run process>'
]

{ #category : #testing }
LanguageLinkManualProcess >> hasProcess [ 
	"Assume that the external process is already running"

	^ true
]

{ #category : #'start-stop' }
LanguageLinkManualProcess >> isRunning [
	"true - the server is controlled externally and assumed to be running"

	^ true
]

{ #category : #'start-stop' }
LanguageLinkManualProcess >> start [
	"Do nothing - the server is controlled externally and assumed to be running"
]

{ #category : #'start-stop' }
LanguageLinkManualProcess >> stop [
	"Do nothing - the server is controlled externally and assumed to be running"
]
