Class {
	#name : #LanguageLinkBrokerHandleMessage,
	#superclass : #LanguageLinkMsgPackPharoBrokerSignal,
	#category : #'PharoLink-Logging'
}

{ #category : #'gt extensions' }
LanguageLinkBrokerHandleMessage >> gtDetails [
	^ super gtDetails , {
		{ 'CommandId' . self message at: #id ifAbsent: [ '' ] }.
		{ 'Value' . (self message at: #value ifPresent: [ :value | MpDecoder decode: value ]) }.
	}
]

{ #category : #accessing }
LanguageLinkBrokerHandleMessage >> signalTypeLabel [
	^ 'BrokerHandleMessage'
]
