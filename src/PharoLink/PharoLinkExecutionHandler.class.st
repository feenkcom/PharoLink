Class {
	#name : 'PharoLinkExecutionHandler',
	#superclass : 'LanguageLinkExecutionHandler',
	#category : 'PharoLink-Execution'
}

{ #category : 'private protocol' }
PharoLinkExecutionHandler >> buildMessageFromCommand: command [
	| message |
	message := LanguageLinkEnqueueCommandMessage 
					commandId: command id 
					statements: command codeForRemote 
					bindings: command bindings.
	message addBinding: #pharoCommandId -> (self serialize: command id).
	^ message
]

{ #category : 'initialization' }
PharoLinkExecutionHandler >> initializeHandler [

	commandQueue := LanguageLinkCommandQueue executionHandler: self.
	mapperFactory := LanguageLinkMapperFactory forExecutionHandler: self.
	promiseRegistry := LanguageLinkPromiseRegistry new.
	weakRegistry := self settings platform weakRegistry.
	objectRegistry := LanguageLinkObjectRegistry new.

	self communicationHandler
		addHandler: [ :msg | self notifyHandler: msg ] forMessageClass: LanguageLinkUpdatePromiseMessage;
		addHandler: [ :msg | self notifyErrorHandler: msg ] forMessageClass: LanguageLinkErrorMessage;
		addHandler: [ :msg | self notifyCallbackHandler: msg ] forMessageClass: LanguageLinkCallbackMessage
]

{ #category : 'handlers' }
PharoLinkExecutionHandler >> notifyCallbackHandler: msg [
	| val serialization |

	val := self 
		signalObserver: (self getObserverAtCommandId: msg commandId id: msg observerId) 
		withValue: (self deserialize: msg value).
	"Callbacks should only return primitives, the registry is on the server side.
	Allow Dictionaries?"
	(PharoLinkRegistry isPrimitive: val) ifFalse: [ val := nil ].
	^ msg createAnswer 
		value: val;
		yourself
]

{ #category : 'registry' }
PharoLinkExecutionHandler >> removeId: aRemoteProxyId [
	"Answer the command that removes the supplied proxy id from the server's registry"

	^ 'llCommand registry clean: ', aRemoteProxyId printString

]
