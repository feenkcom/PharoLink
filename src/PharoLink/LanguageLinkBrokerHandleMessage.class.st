Class {
	#name : #LanguageLinkBrokerHandleMessage,
	#superclass : #LanguageLinkMsgPackPharoBrokerSignal,
	#category : 'PharoLink-Logging'
}

{ #category : #'gt extensions' }
LanguageLinkBrokerHandleMessage >> gtDetails [
	| details |
	details := super gtDetails , {
		{ 'CommandId' . self message at: #id ifAbsent: [ self message at: #commandId ifAbsent: [ '' ] ] }.
		{ 'Value' . (self message at: #value ifPresent: [ :value | MpDecoder decode: value ]) }.
	}.
	self message at: #type ifPresent: [ :msgType | 
		msgType = 'ERR'
			ifTrue: [
				message at: #errMsg ifPresent: [ :errorMsg |
					details := details , { { 'ErrorMessage' . errorMsg } } ] ] ].
	^ details
]

{ #category : #accessing }
LanguageLinkBrokerHandleMessage >> signalTypeLabel [
	^ 'BrokerHandleMessage'
]
