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
		'commandFactoryClass',
		'commandClass',
		'platform'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #'instance creation' }
LanguageLinkSettings class >> jsDefaultSettings [

	^ self new 
		clientSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (7000 + 99 atRandom));
		serverSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (6900 + 99 atRandom));
		messageBrokerStrategy: LanguageLinkHttpMessageBroker;
		serverProcessClass: JSLinkPharoNodejsProcess;
		platform: JSLinkPharoPlatform new;
		commandFactoryClass: JSLinkCommandFactory;
		commandClass: LanguageLinkCommand;
		yourself
]

{ #category : #'instance creation' }
LanguageLinkSettings class >> pharoDefaultSettings [

	^ self new 
		clientSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (7000 + 99 atRandom));
		serverSocketAddress: (LanguageLinkSocketAddress 
				ipOrName: 'localhost' port: (6900 + 99 atRandom));
		messageBrokerStrategy: LanguageLinkHttpMessageBroker;
		serverProcessClass: PharoLinkPharoProcess;
		serverExecutable: FileLocator imageDirectory / 'vmgt/gtoolkit';
		platform: PharoLinkPharoPlatform new;
		commandFactoryClass: PharoLinkCommandFactory;
		commandClass: PharoLinkCommand;
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
LanguageLinkSettings >> platform [
	^ platform
]

{ #category : #accessing }
LanguageLinkSettings >> platform: anObject [
	platform := anObject
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
