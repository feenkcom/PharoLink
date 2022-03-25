Class {
	#name : #LanguageLinkCommunicationHandler,
	#superclass : #LanguageLinkHandler,
	#instVars : [
		'messageBroker'
	],
	#category : #'PharoLink-Core'
}

{ #category : #adding }
LanguageLinkCommunicationHandler >> addHandler: aBlock forMessageClass: messageClass [
	^ messageBroker addCallback: aBlock messageClass: messageClass
]

{ #category : #initialization }
LanguageLinkCommunicationHandler >> initializeHandler [
	super initializeHandler.
	messageBroker := self application settings messageBroker
]

{ #category : #testing }
LanguageLinkCommunicationHandler >> isRunning [ 

	^ messageBroker isRunning
]

{ #category : #testing }
LanguageLinkCommunicationHandler >> isServerReady [
	| semaphore process ans |

	semaphore := Semaphore new.
	process := [ ans := [ 
				self sendMessage:
					(LanguageLinkIsAliveMessage forApplication: self application).
				true ]
			on: LanguageLinkCommunicationError
			do: [ :e | false ].
		semaphore signal ] forkAt: Processor lowIOPriority.
	semaphore waitTimeoutMSecs: 4000.
	[ process terminate ]
		on: ProcessAlreadyTerminating
		do: [ "noop" ].
	^ ans notNil and: ans
]

{ #category : #adding }
LanguageLinkCommunicationHandler >> sendMessage: aMessage [
	^ messageBroker sendMessage: aMessage
]

{ #category : #accessing }
LanguageLinkCommunicationHandler >> start [
	^ messageBroker start
]

{ #category : #accessing }
LanguageLinkCommunicationHandler >> stop [
	^ messageBroker stop
]
