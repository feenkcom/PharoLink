Class {
	#name : #LanguageLinkBrokerSendMessage,
	#superclass : #LanguageLinkMsgPackPharoBrokerSignal,
	#category : 'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkBrokerSendMessage >> decodedBindings [
	| rawBindings decodedBindings |
	rawBindings := self message at: #bindings ifAbsent: [ ^ #() ].
	decodedBindings := Dictionary new.
	rawBindings keysAndValuesDo: [ :key :value |
		decodedBindings at: key put: (MpDecoder decode: value) ].
	^ decodedBindings
]

{ #category : #'gt extensions' }
LanguageLinkBrokerSendMessage >> gtDetails [
	^ super gtDetails , {
		{ 'CommandId' . self message at: #commandId ifAbsent: [ '' ] }.
		{ 'Bindings' . self decodedBindings }.
		{ 'Statements' . self message at: #statements ifAbsent: [ '' ] }.
	}
]

{ #category : #accessing }
LanguageLinkBrokerSendMessage >> signalTypeLabel [
	^ 'BrokerSendMessage'
]
