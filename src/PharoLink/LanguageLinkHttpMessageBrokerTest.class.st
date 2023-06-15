"
This class contains tests

"
Class {
	#name : #LanguageLinkHttpMessageBrokerTest,
	#superclass : #LanguageLinkMessageBrokerTest,
	#instVars : [
		'stubServer'
	],
	#category : #'PharoLink-Tests'
}

{ #category : #utils }
LanguageLinkHttpMessageBrokerTest >> answer: aDictionary [
	^ aDictionary
]

{ #category : #utils }
LanguageLinkHttpMessageBrokerTest >> buildAndStartStubServer [
	stubServer := ZnServer on: settings serverSocketAddress port.
	stubServer start.
	stubServer onRequestRespond: [ :req | self primHandle: req ]
]

{ #category : #utils }
LanguageLinkHttpMessageBrokerTest >> decodeAnswer: jsonText [
	^ NeoJSONReader fromString: jsonText
]

{ #category : #running }
LanguageLinkHttpMessageBrokerTest >> defaultSettings [

	^ LanguageLinkSettings jsDefaultSettings

]

{ #category : #utils }
LanguageLinkHttpMessageBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #hooks }
LanguageLinkHttpMessageBrokerTest >> messageBrokerClass [
	^ LanguageLinkHttpMessageBroker
]

{ #category : #private }
LanguageLinkHttpMessageBrokerTest >> primHandle: aRequest [
	| answer |
	answer := [
		handlerBlock value: 
			aRequest uri asString allButFirst 
				-> (NeoJSONReader fromString: aRequest contents)
		] on: Error do: [ :e | 
			handlerException := e.
			^ self errorResponse ].
	answer := [ LanguageLinkNeoJsonSerializer new serialize: answer ] on: Error do: [ '{}' ].
	^ ZnResponse ok: (ZnEntity json: answer)
]

{ #category : #hooks }
LanguageLinkHttpMessageBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerEquals: Dictionary new
]

{ #category : #hooks }
LanguageLinkHttpMessageBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	| ans |
	ans := ZnEasy 
				post: self brokerUri , '/' , (dict at: #type)
				data: (ZnEntity json: (NeoJSONWriter toString: dict)).
	ans status = 200 ifFalse: [ LanguageLinkCommunicationError signal: ans status asString ].
	aBlock value: (self decodeAnswer: ans contents)
]

{ #category : #utils }
LanguageLinkHttpMessageBrokerTest >> sleepAWhile [
	"With HTTP there is no need to sleep."
]

{ #category : #running }
LanguageLinkHttpMessageBrokerTest >> stopStubServer [
	stubServer ifNotNil: [ stubServer stop ]
]
