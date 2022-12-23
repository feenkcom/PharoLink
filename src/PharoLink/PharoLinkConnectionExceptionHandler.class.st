"
Handle exceptions raised while communicating and processing messages.
"
Class {
	#name : #PharoLinkConnectionExceptionHandler,
	#superclass : #Object,
	#category : #'PharoLink-Platform'
}

{ #category : #api }
PharoLinkConnectionExceptionHandler >> handleExceptionsDuring: aBlock [

	aBlock
		on: PrimitiveFailed
		do: [ :ex |
			LanguageLinkSocketErrorSignal new
				message: 'LanguageLinkMsgPackPharoBroker: exiting message handling';
				emit ].
]
