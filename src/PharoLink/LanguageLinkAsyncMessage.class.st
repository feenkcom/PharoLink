Class {
	#name : 'LanguageLinkAsyncMessage',
	#superclass : 'LanguageLinkMessage',
	#category : 'PharoLink-Platform-Messages'
}

{ #category : 'accessing' }
LanguageLinkAsyncMessage class >> type [
	^ #ASYNC
]

{ #category : 'testing' }
LanguageLinkAsyncMessage >> isSync [
	^ false
]
