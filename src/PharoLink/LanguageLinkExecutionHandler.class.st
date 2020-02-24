"
LanguageLinkExecutionHandler is responsible for: 

- converting a sequence of statements to source code for the remote environment.
- registering proxy objects.
- and more...
 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	commandQueue:		<Object>
	mapperFactory:		<Object>
	objectRegistry:		<Object>
	promiseRegistry:		<Object>
	weakRegistry:		<Object>


    Implementation Points
"
Class {
	#name : #LanguageLinkExecutionHandler,
	#superclass : #LanguageLinkHandler,
	#instVars : [
		'commandQueue',
		'weakRegistry',
		'objectRegistry',
		'promiseRegistry',
		'mapperFactory'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> buildMessageFromCommand: command [
	| message |
	message := LanguageLinkEnqueueCommandMessage 
					commandId: command id 
					statements: command codeForRemote 
					bindings: (command bindings asDictionary collect: [ :obj | self serialize: obj ]).
	message addBinding: #pharoCommandId -> (self serialize: command id).
	^ message
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> deserialize: anObject [
	^ mapperFactory deserializer deserialize: anObject
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> getObserverAtCommandId: commandId id: observerId [
	^ (commandQueue getCommand: commandId) getObserver: observerId
]

{ #category : #initialization }
LanguageLinkExecutionHandler >> initializeHandler [

	commandQueue := JSLinkCommandQueue executionHandler: self.
	mapperFactory := JSLinkMapperFactory forExecutionHandler: self.
	promiseRegistry := JSLinkPromiseRegistry new.
	weakRegistry := self settings platform weakRegistry.
	objectRegistry := JSLinkObjectRegistry new.

	self communicationHandler
		addHandler: [ :msg | self notifyHandler: msg ] forMessageClass: LanguageLinkUpdatePromiseMessage;
		addHandler: [ :msg | self notifyErrorHandler: msg ] forMessageClass: LanguageLinkErrorMessage;
		addHandler: [ :msg | self notifyCallbackHandler: msg ] forMessageClass: LanguageLinkCallbackMessage
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> mapperFactory [
	^ mapperFactory
]

{ #category : #'as yet unclassified' }
LanguageLinkExecutionHandler >> newCommandFactory [

	^ self application newCommandFactory
]

{ #category : #handlers }
LanguageLinkExecutionHandler >> notifyCallbackHandler: msg [
	| val serialization |
	val := self 
		signalObserver: (self getObserverAtCommandId: msg commandId id: msg observerId) 
		withValue: (self deserialize: msg value).
	serialization := [ self serialize: val ] on: Error do: [ :err | 
		self application log: err printString.
		self serialize: nil ].
	^ msg createAnswer 
		value: serialization;
		yourself
]

{ #category : #handlers }
LanguageLinkExecutionHandler >> notifyErrorHandler: errorMsg [
	| error |
	error := JSLinkJavaScriptError new
					application: self application;
					command: (commandQueue getCommand: errorMsg commandId);
					errorMessage: errorMsg errorMessage;
					trace: errorMsg trace;
					yourself.
	self safeTriggerDebugger: error.
	^ errorMsg createAnswer 
			handlingAction: error proceedAction;
			yourself
]

{ #category : #handlers }
LanguageLinkExecutionHandler >> notifyHandler: updatePromiseMsg [
	self 
		updatePromiseId: updatePromiseMsg promiseId 
		with: (self deserialize: updatePromiseMsg value)
]

{ #category : #initialization }
LanguageLinkExecutionHandler >> objectRegistry [
	^ objectRegistry
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> primitiveSendCommand: command [
	^ self communicationHandler sendMessage: (self buildMessageFromCommand: command)
]

{ #category : #'as yet unclassified' }
LanguageLinkExecutionHandler >> registerObject: aPythonObject [
	objectRegistry registerObject: aPythonObject.
	weakRegistry 
		registerObject: aPythonObject 
		finalizer: (JSLinkRegistryFinalizer 
							javaScriptVariable: aPythonObject javaScriptVariable 
							executionHandler: self)
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> registerPromiseForCommand: aCommand [
	| promise |
	promise := JSLinkPromise new
					id: aCommand id;
					transformBlock: aCommand transformBlock;
					yourself.
	aCommand promise: promise.
	promiseRegistry addPromise: promise.
	^ promise
]

{ #category : #'as yet unclassified' }
LanguageLinkExecutionHandler >> safeTriggerDebugger: error [
	| sem |

	[ promiseRegistry signalPromiseId: error command id with: error ] fork.

	"sem := Semaphore new.
	[ [ self triggerDebugger: error ] ensure: [ sem signal ] ]
		on: JSLinkPythonError fork: [ :e | JSLinkPlatform current uiManager spawnDebuggerOnException: e ].
	sem wait.
	^ error proceedAction: error defaultProceedAction"
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> sendCommand: command [
	| promise |
	self assert: command isValid.
	commandQueue enqueueCommand: command.
	promise := self registerPromiseForCommand: command.
	self primitiveSendCommand: command.
	^ promise
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> serialize: anObject [
	^ mapperFactory serializer serialize: anObject
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> signalObserver: observer withValue: object [
	^ observer pharoNotify: object
]

{ #category : #accessing }
LanguageLinkExecutionHandler >> stop [
	super stop.
	weakRegistry destroy
]

{ #category : #'as yet unclassified' }
LanguageLinkExecutionHandler >> triggerDebugger: pythonError [
	"This method is called when an error rised on Python execution."
	"Inspect error to review the Command that caused the error.
	For ignoring error:
		pythonError proceedAction: PBIgnore new
	For aborting:
		pythonError proceedAction: PBDropQueue new
	For replacing the command that caused the error:
		pythonError proceedAction: P3ReplaceCommandAction new newCommand: **Your crafted command**
	To execute your action you just need to 'Proceed' in the debugger."
	pythonError signal.
]

{ #category : #'private protocol' }
LanguageLinkExecutionHandler >> updatePromiseId: id with: anObject [
	commandQueue finishCommandId: id.
	promiseRegistry removeAndSignalPromiseId: id with: anObject
]
