"
Handle exceptions raised while communicating and processing messages.
"
Class {
	#name : #PharoLinkConnectionExceptionHandler,
	#superclass : #Object,
	#category : #'PharoLink-Platform'
}

{ #category : #api }
PharoLinkConnectionExceptionHandler >> handleExceptionsDuring: aBlock for: msgBroker [

	aBlock
		on: PrimitiveFailed, NetworkError
		do: [ :ex |
			"If the client has been told to stop, give it time to register"
			1 second wait.
			msgBroker isRunning ifTrue:
				[ ex pass ]
			ifFalse:
				[ LanguageLinkSocketErrorSignal new
					message: 'LanguageLinkMsgPackPharoBroker: exiting message handling';
					emit ] ].
]
