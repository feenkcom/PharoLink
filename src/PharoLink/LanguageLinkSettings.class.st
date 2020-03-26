Class {
	#name : #LanguageLinkSettings,
	#superclass : #Object,
	#instVars : [
		'debugMode',
		'clientSocketAddress',
		'serverSocketAddress',
		'messageBroker',
		'messageBrokerStrategy',
		'serverProcessClass',
		'serverExecutable',
		'serverImage',
		'commandFactoryClass',
		'commandClass',
		'platform',
		'serializerClass',
		'deserializerClass',
		'parserClass'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #'instance creation' }
LanguageLinkSettings class >> pharoDefaultSettings [

	^ self new 
		clientSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (7000 + 99 atRandom));
		serverSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (6900 + 99 atRandom));
		messageBrokerStrategy: LanguageLinkHttpMessageBroker;
		serverProcessClass: PharoLinkPharoProcess;
		serverExecutable: FileLocator vmBinary resolve;
		serverImage: FileLocator image resolve;
		platform: PharoLinkPharoPlatform new;
		commandFactoryClass: PharoLinkCommandFactory;
		commandClass: PharoLinkCommand;
		serializerClass: LanguageLinkSerializer;
		deserializerClass: PharoLinkDeserializer;
		parserClass: StParser;
		yourself
]

{ #category : #accessing }
LanguageLinkSettings >> clientSocketAddress [
	^ clientSocketAddress
]

{ #category : #accessing }
LanguageLinkSettings >> clientSocketAddress: anObject [
	clientSocketAddress := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> commandClass [
	^ commandClass
]

{ #category : #accessing }
LanguageLinkSettings >> commandClass: anObject [
	commandClass := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> commandFactoryClass [
	^ commandFactoryClass
]

{ #category : #accessing }
LanguageLinkSettings >> commandFactoryClass: anObject [
	commandFactoryClass := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> debugMode [
	^ debugMode
]

{ #category : #accessing }
LanguageLinkSettings >> debugMode: anObject [
	debugMode := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> deserializerClass [
	^ deserializerClass
]

{ #category : #accessing }
LanguageLinkSettings >> deserializerClass: anObject [
	deserializerClass := anObject
]

{ #category : #initialization }
LanguageLinkSettings >> initialize [

	super initialize.
	debugMode := false.
]

{ #category : #accessing }
LanguageLinkSettings >> messageBroker [

	^ messageBroker ifNil: [ messageBroker := self messageBrokerStrategy settings: self ]
]

{ #category : #accessing }
LanguageLinkSettings >> messageBrokerStrategy [
	^ messageBrokerStrategy
]

{ #category : #accessing }
LanguageLinkSettings >> messageBrokerStrategy: anObject [
	messageBrokerStrategy := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> parserClass [
	^ parserClass
]

{ #category : #accessing }
LanguageLinkSettings >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> platform [
	^ platform
]

{ #category : #accessing }
LanguageLinkSettings >> platform: anObject [
	platform := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> serializerClass [
	^ serializerClass
]

{ #category : #accessing }
LanguageLinkSettings >> serializerClass: anObject [
	serializerClass := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> serverExecutable [
	^ serverExecutable
]

{ #category : #accessing }
LanguageLinkSettings >> serverExecutable: anObject [
	serverExecutable := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> serverImage [
	^ serverImage
]

{ #category : #accessing }
LanguageLinkSettings >> serverImage: anObject [
	serverImage := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> serverProcessClass [
	^ serverProcessClass
]

{ #category : #accessing }
LanguageLinkSettings >> serverProcessClass: anObject [
	serverProcessClass := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> serverSocketAddress [
	^ serverSocketAddress
]

{ #category : #accessing }
LanguageLinkSettings >> serverSocketAddress: anObject [
	serverSocketAddress := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> workingDirectory [ 

	^ self platform folderForApplication
]
