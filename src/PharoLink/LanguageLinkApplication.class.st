Class {
	#name : #LanguageLinkApplication,
	#superclass : #Object,
	#instVars : [
		'communicationHandler',
		'processHandler',
		'loggingHandler',
		'executionHandler',
		'settings'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'PharoLink-Global'
}

{ #category : #accessing }
LanguageLinkApplication class >> baseApplication [
	^ JSLinkApplication
]

{ #category : #accessing }
LanguageLinkApplication class >> defaultSettings [

	^ LanguageLinkSettings pharoDefaultSettings
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> do: aBlockClosure [ 
	| retVal |
	self isRunning ifTrue: [ ^ aBlockClosure value ].
	[
		self start.
		retVal := aBlockClosure cull: self uniqueInstance.
		self uniqueInstance commandFactory << nil.
		self uniqueInstance commandFactory send waitForValue. ] ensure: [ self stop ].
	^ retVal
]

{ #category : #testing }
LanguageLinkApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
]

{ #category : #testing }
LanguageLinkApplication class >> module [
	^ self uniqueInstance module
]

{ #category : #'instance creation' }
LanguageLinkApplication class >> newWith: aLLSettings [
	"Answer a new instance initialised with the supplied settings"

	^ self new initializeWith: aLLSettings 
]

{ #category : #'pipenv setup' }
LanguageLinkApplication class >> platform [
	^ JSLinkPlatform current
]

{ #category : #'python hooks file' }
LanguageLinkApplication class >> repositoryFileReference [
	^ self platform folderForApplication
]

{ #category : #instructions }
LanguageLinkApplication class >> resetUniqueInstance [
	uniqueInstance ifNotNil: [ 
		[ uniqueInstance stop ] 
			on: Error 
			do: [ JSLinkPlatform current uiManager inform: 'Error on reseting unique instance.' ]. ].
	uniqueInstance := nil
]

{ #category : #instructions }
LanguageLinkApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> start [

	^ self startWith: LanguageLinkSettings pharoDefaultSettings.
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> startWith: settings [

	self isRunning ifTrue: [ Error signal: self name, ' already running.' ].
	self stop.
	uniqueInstance := self new initializeWith: settings.
	uniqueInstance start.
	^ uniqueInstance.
]

{ #category : #'start-stop' }
LanguageLinkApplication class >> stop [
	uniqueInstance ifNotNil: [ 
		uniqueInstance stop. ].
	uniqueInstance := nil
]

{ #category : #testing }
LanguageLinkApplication class >> test [ 
	self assert: (self do: [ :app |
		app commandFactory << (JSGBinaryOperator new
                     left: 1;
                     right: 2;
                     operator: $+;
                     yourself).
		app commandFactory send waitForValue
	  ]) = 3
]

{ #category : #instructions }
LanguageLinkApplication class >> uniqueInstance [
	^ uniqueInstance
]

{ #category : #accessing }
LanguageLinkApplication class >> uniqueInstance: anObject [
	uniqueInstance := anObject
]

{ #category : #'instance creation' }
LanguageLinkApplication class >> withDefaultSettings [
	"Answer a new instance configured with default settings"

	^ self newWith: self defaultSettings
]

{ #category : #utils }
LanguageLinkApplication >> addMapping: jsType to: mapFunction [

		^ self subclassResponsibility 
]

{ #category : #accessing }
LanguageLinkApplication >> commandFactory [

	self deprecated: 'Use #newCommandFactory'.
	^ self subclassResponsibility 
]

{ #category : #accessing }
LanguageLinkApplication >> communicationHandler [
	^ communicationHandler
]

{ #category : #accessing }
LanguageLinkApplication >> debugMode [

	^ settings debugMode
]

{ #category : #accessing }
LanguageLinkApplication >> debugMode: aBoolean [

	settings debugMode: aBoolean
]

{ #category : #accessing }
LanguageLinkApplication >> errorMessage [
	"Fetch the error message from the stderr stream, from the processhander"
	^ processHandler errorMessage
]

{ #category : #'as yet unclassified' }
LanguageLinkApplication >> evaluateSourceSequence: aString [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		<< aString;
		sendAndWait.

]

{ #category : #accessing }
LanguageLinkApplication >> executionHandler [
	^ executionHandler
]

{ #category : #ui }
LanguageLinkApplication >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		priority: 10;
		text: [ '' asRopedText attributesBuilder attribute: (BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler) ];
		styler: self settings parserClass gtStyler;
		actionButtonIcon: BrGlamorousIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				result := [ self evaluateSourceSequence: statements ]
					on: PharoLinkRemoteError, PharoLinkParserError
					do: [ :ex | ex ].
				aButton phlow spawnObject: result ].

]

{ #category : #handlers }
LanguageLinkApplication >> handlers [
	^ Array
		with: loggingHandler
		with: communicationHandler
		with: processHandler
		with: executionHandler
]

{ #category : #initialization }
LanguageLinkApplication >> initializeHandlers [

	^ self subclassResponsibility 
]

{ #category : #initialization }
LanguageLinkApplication >> initializeWith: aLLSettings [

	settings := aLLSettings.
	self initializeHandlers.
]

{ #category : #testing }
LanguageLinkApplication >> isRunning [
	^ self handlers allSatisfy: #isRunning
]

{ #category : #testing }
LanguageLinkApplication >> isServerReady [
	"Ensures python webserver is ready for receiving commands"
	^ self communicationHandler isServerReady
]

{ #category : #logging }
LanguageLinkApplication >> log: aLog [
	self loggingHandler log: aLog
]

{ #category : #accessing }
LanguageLinkApplication >> loggingHandler [
	^ loggingHandler
]

{ #category : #accessing }
LanguageLinkApplication >> module [
	self subclassResponsibility
]

{ #category : #'instance creation' }
LanguageLinkApplication >> newCommand [

	^ self settings commandClass forApplication: self.
]

{ #category : #'instance creation' }
LanguageLinkApplication >> newCommandFactory [
	^ self settings commandFactoryClass new 
		application: self;
		yourself
]

{ #category : #accessing }
LanguageLinkApplication >> platform [ 

	^self settings platform
]

{ #category : #accessing }
LanguageLinkApplication >> postInitialization [
	
]

{ #category : #accessing }
LanguageLinkApplication >> processHandler [
	^ processHandler
]

{ #category : #accessing }
LanguageLinkApplication >> registerObject: aProxyObject [

	self executionHandler registerObject: aProxyObject
]

{ #category : #instructions }
LanguageLinkApplication >> send: aCommand [
	self isRunning ifFalse: [ Error signal: 'Server not running.' ].
	^ executionHandler sendCommand: aCommand
]

{ #category : #accessing }
LanguageLinkApplication >> settings [
	^ settings
]

{ #category : #accessing }
LanguageLinkApplication >> settings: anObject [
	settings := anObject
]

{ #category : #accessing }
LanguageLinkApplication >> start [
	self handlers do: #start.
	self waitInitialization.
	self postInitialization.
	self newCommandFactory send.
]

{ #category : #'start-stop' }
LanguageLinkApplication >> stop [
	self handlers select: #notNil thenDo: #stop
]

{ #category : #initialization }
LanguageLinkApplication >> waitInitialization [
	"Timeout of 10 seconds and try every 0.5 seconds"
	1 to: 10 by: 0.5 do: [ :t |
		self isServerReady 
				ifTrue: [ ^ self ]
				ifFalse: [ (Delay forMilliseconds: 500) wait ] ].
	Error signal: 'The server initialization failed!'.
	"
	Print the result of executing the following line:
	
	self errorMessage
	"
]
