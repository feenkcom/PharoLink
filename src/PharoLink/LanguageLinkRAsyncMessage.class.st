Class {
	#name : 'LanguageLinkRAsyncMessage',
	#superclass : 'LanguageLinkRMessage',
	#category : 'PharoLink-Platform-Messages'
}

{ #category : 'accessing' }
LanguageLinkRAsyncMessage class >> type [
	^ #RASYNC
]

{ #category : 'testing' }
LanguageLinkRAsyncMessage >> isSync [
	^ false
]
