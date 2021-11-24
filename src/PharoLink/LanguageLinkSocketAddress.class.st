Class {
	#name : #LanguageLinkSocketAddress,
	#superclass : #Object,
	#instVars : [
		'ipOrName',
		'port'
	],
	#category : 'PharoLink-Platform'
}

{ #category : #accessing }
LanguageLinkSocketAddress class >> from: aString [

	"Parse an address in the form <host>:<port> in to a LanguageLinkSocketAddress"

	| segments hostname port |
	segments := $: split: aString.
	segments size > 2 ifFalse: [ 
		self error:
			aString printString , ' must be formatted [<host>:]<port>' ].
	segments size = 1
		ifTrue: [ 
			hostname := 'localhost'.
			port := aString ]
		ifFalse: [ 
			hostname := segments first.
			port := segments second ].
	(port allSatisfy: #isDigit) ifFalse: [ 
		self error: aString printString , ' the port must be a number' ].
	^ self ipOrName: hostname port: port asInteger
]

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
