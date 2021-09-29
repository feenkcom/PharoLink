Class {
	#name : 'LanguageLinkMessageHandlerTest',
	#superclass : 'TestCase',
	#category : 'PharoLink-Platform'
}

{ #category : 'tests' }
LanguageLinkMessageHandlerTest >> testAsyncMessage [
	| flag msg handler |
	flag := false.
	msg := LanguageLinkAsyncMessage new.
	handler := LanguageLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true ].
	self deny: flag.
	handler handleMessage.
	self deny: handler shouldAnswer.
	self assert: flag.
	self should: [ handler answer ] raise: Error
]

{ #category : 'tests' }
LanguageLinkMessageHandlerTest >> testRAsyncMessage [
	| flag msg handler |
	flag := false.
	msg := LanguageLinkRAsyncMessage new.
	handler := LanguageLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true ].
	self deny: flag.
	handler handleMessage.
	self deny: handler shouldAnswer.
	self assert: flag.
	self should: [ handler answer ] raise: Error
]

{ #category : 'tests' }
LanguageLinkMessageHandlerTest >> testRSyncMessage [
	| flag msg handler ans |
	flag := false.
	ans := nil.
	msg := LanguageLinkRSyncMessage new.
	handler := LanguageLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true.
							ans := msg createAnswer ].
	self deny: flag.
	handler handleMessage.
	self assert: handler shouldAnswer.
	self assert: flag.
	self assert: handler answer equals: ans
]

{ #category : 'tests' }
LanguageLinkMessageHandlerTest >> testSyncMessage [
	| flag msg handler ans |
	flag := false.
	ans := nil.
	msg := LanguageLinkSyncMessage new.
	handler := LanguageLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true.
							ans := msg createAnswer ].
	self deny: flag.
	handler handleMessage.
	self assert: handler shouldAnswer.
	self assert: flag.
	self assert: handler answer equals: ans
]
