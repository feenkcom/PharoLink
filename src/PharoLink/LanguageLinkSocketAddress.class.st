Class {
	#name : #LanguageLinkSocketAddress,
	#superclass : #Object,
	#instVars : [
		'ipOrName',
		'port'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #'as yet unclassified' }
LanguageLinkSocketAddress class >> ipOrName: ipOrName port: aPort [
	^ self new
			ipOrName: ipOrName;
			port: aPort;
			yourself
]

{ #category : #accessing }
LanguageLinkSocketAddress >> ipOrName [
	^ ipOrName
]

{ #category : #accessing }
LanguageLinkSocketAddress >> ipOrName: anObject [
	ipOrName := anObject
]

{ #category : #accessing }
LanguageLinkSocketAddress >> port [
	^ port
]

{ #category : #accessing }
LanguageLinkSocketAddress >> port: anObject [
	port := anObject
]

{ #category : #printing }
LanguageLinkSocketAddress >> printAddress [
	^ ipOrName , ':' , port asString
]

{ #category : #printing }
LanguageLinkSocketAddress >> printOn: aStream [

	(ipOrName isNil or: [ port isNil ]) ifTrue:
		[ ^ super printOn: aStream ].

	aStream
		<< ipOrName;
		nextPut: $:;
		print: port
]
