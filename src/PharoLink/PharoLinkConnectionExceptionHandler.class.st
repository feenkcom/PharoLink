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
		"Sockets signal SocketError instead of PrimitiveFailed in Pharo 11, 
		PrimitiveFailed should be removed from here when Pharo 10 compatibility is dropped"
		on: (ExceptionSet withClassNames: #(#PrimitiveFailed #SocketError #NetworkError))
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
