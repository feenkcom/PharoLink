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
		'parserClass',
		'serverDebugMode',
		'workingDirectory',
		'connectionExceptionHandler'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #'instance creation' }
LanguageLinkSettings class >> headlessUnixVmFilenameFrom: aFileReference [
	| gtIndex basename |

	basename := aFileReference basename.
	(basename includesSubstring: '-cli') ifTrue: [ ^ aFileReference ].

	gtIndex := basename indexOfSubCollection: 'GlamorousToolkit'.
	gtIndex = 0 ifTrue: [ self error: 'Unrecognised vm executable name' ].
	^ aFileReference parent /
		((basename copyFrom: 1 to: gtIndex + 15),
		'-cli',
		(basename copyFrom: gtIndex + 16 to: basename size))
]

{ #category : #'instance creation' }
LanguageLinkSettings class >> headlessVmFilenameFrom: aFileReference [

	^ Smalltalk platform isWindows
		ifTrue: [ self headlessWindowsVmFilenameFrom: aFileReference ]
		ifFalse: [ self headlessUnixVmFilenameFrom: aFileReference ]
]

{ #category : #'instance creation' }
LanguageLinkSettings class >> headlessWindowsVmFilenameFrom: aFileReference [

	^ (aFileReference basename endsWith: '-cli.exe') 
		ifTrue: [ aFileReference ]
		ifFalse: [ | parts |
			parts := '.' split: aFileReference basename.
			aFileReference parent / (parts first , '-cli.' , parts second) ]
]

{ #category : #'instance creation' }
LanguageLinkSettings class >> pharoDefaultSettings [
	| binary |

	binary := self headlessVmFilenameFrom: FileLocator vmBinary resolve.
	^ self new
		  serverSocketAddress: (LanguageLinkSocketAddress
				   ipOrName: 'localhost'
				   port: 6900 + 99 atRandom);
		  messageBrokerStrategy: LanguageLinkMsgPackPharoBroker;
		  connectionExceptionHandler: PharoLinkConnectionExceptionHandler new;
		  serverProcessClass: PharoLinkPharoProcess;
		  serverExecutable: binary;
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
LanguageLinkSettings >> connectionExceptionHandler [

	^ connectionExceptionHandler
]

{ #category : #accessing }
LanguageLinkSettings >> connectionExceptionHandler: anObject [

	connectionExceptionHandler := anObject
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

{ #category : #ui }
LanguageLinkSettings >> gtSettingsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Settings';
		priority: 1;
		items: [ self settingNames ];
		column: #Item 
			text: [ :item | item ] 
			width: 170;
		column: #Value 
			text: [ :item | item value: self ];
		send: [ :item | item value: self ]
]

{ #category : #initialization }
LanguageLinkSettings >> initialize [

	super initialize.
	debugMode := false.
	serverDebugMode := false.

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
	"Set the platform.
	This must be done before changing the workingDirectory."

	platform := anObject.
	"The platform knows the default workingDirectory"
	workingDirectory := platform folderForApplication.
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
LanguageLinkSettings >> serverDebugMode [
	"Answer a boolean indicating whether the server should be started with the debugger enabled.
	Only supported on JSLink at the moment"

	^ serverDebugMode
]

{ #category : #accessing }
LanguageLinkSettings >> serverDebugMode: anObject [
	serverDebugMode := anObject
]

{ #category : #accessing }
LanguageLinkSettings >> serverExecutable [
	^ serverExecutable
]

{ #category : #accessing }
LanguageLinkSettings >> serverExecutable: aFileReference [
	serverExecutable := aFileReference
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
LanguageLinkSettings >> settingNames [

	^ self class allInstVarNames sorted
]

{ #category : #accessing }
LanguageLinkSettings >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
LanguageLinkSettings >> workingDirectory: aFileReference [
	"Set the working directory where the runtime environment is installed.
	This must be changed after the platform has been set."

	workingDirectory := aFileReference
]
