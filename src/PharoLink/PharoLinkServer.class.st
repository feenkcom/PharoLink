Class {
	#name : #PharoLinkServer,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'listenPort',
		'listenProcess',
		'debugMode',
		'globals',
		'serverSocket',
		'connections',
		'announcer'
	],
	#category : #'PharoLink-Server'
}

{ #category : #clap }
PharoLinkServer class >> commandLine [
	<commandline>

	^ self commandLineCommand meaning: [ :args | 
		  | logger listenPort |
		  args at: #help ifPresent: [ :help | 
			  help value.
			  help context exitSuccess ].

		  args at: #log ifPresent: [ 
			  SignalLogger resetAllInstances.
			  logger := RestartingStreamLogger stdout.
			  logger start ].

		  listenPort := (args at: #listenPort) value asNumber.
		  StringSignal emit: 'Listen Port: ' , listenPort printString.
		  self new
			  listenPort: listenPort;
			  start.
		  StringSignal emit: 'Running'.

		  "Wait until the process is killed"
		  Semaphore new wait ]
]

{ #category : #clap }
PharoLinkServer class >> commandLineCommand [

	^ (ClapCommand id: 'pharoLinkServer')
		  description: 'Run the PharoLink Server';
		  add: ClapFlag forHelp;
		  add: ((ClapFlag id: 'log') description: 'Enable logging to stdout');
		  add: ((ClapPositional id: 'listenPort') description:
					   'The port number on which to listen for requests');
		  yourself
]

{ #category : #private }
PharoLinkServer >> addConnection: aPharoLinkServerConnection [

	connections add: aPharoLinkServerConnection.
	self announce: (PharoLinkServerConnectionConnectedAnnouncement connection: aPharoLinkServerConnection)
]

{ #category : #announcer }
PharoLinkServer >> announce: anAnnouncement [

	^ self announcer announce: anAnnouncement
]

{ #category : #announcer }
PharoLinkServer >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #accessing }
PharoLinkServer >> debugMode [
	^ debugMode
]

{ #category : #accessing }
PharoLinkServer >> globals [

	^ globals
]

{ #category : #private }
PharoLinkServer >> handleIsAlive: aZnRequest [
	"Respond to the ping request"

	^ (ZnResponse statusLine: ZnStatusLine ok)
		entity: (ZnEntity json: '{}');
		yourself
]

{ #category : #announcer }
PharoLinkServer >> hasSubscriber: anObject [

	^ self announcer hasSubscriber: anObject
]

{ #category : #initialization }
PharoLinkServer >> initialize [ 

	super initialize.
	globals := Dictionary new.
	debugMode := false.
	connections := OrderedCollection new.
	announcer := Announcer new.
]

{ #category : #testing }
PharoLinkServer >> isRunning [ 

	^ serverSocket isNotNil
]

{ #category : #private }
PharoLinkServer >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : #accessing }
PharoLinkServer >> listenPort [
	^ listenPort
]

{ #category : #accessing }
PharoLinkServer >> listenPort: anObject [
	listenPort := anObject
]

{ #category : #'start-stop' }
PharoLinkServer >> newConnection: aSocket [

	^ PharoLinkServerConnection server: self socket: aSocket
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> removeSubscription: subscription [
	"Remove the given subscription from the receiver"

	^ self announcer removeSubscription: subscription
]

{ #category : #'start-stop' }
PharoLinkServer >> setDebugMode [

	debugMode := true.

]

{ #category : #private }
PharoLinkServer >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #'start-stop' }
PharoLinkServer >> start [

	"Start the receiver's listenProcess.
	This will accept connections and create a {{gtClass:PharoLinkServerConnection}} for each connection."

	self assert: listenPort isNotNil.

	serverSocket := LanguageLinkMsgPackUtils serverSocketOn: listenPort.
	listenProcess := [ 
	                 | bindSocket |
	                 [ 
	                 [ bindSocket isNil ] whileTrue: [ 
		                 bindSocket := serverSocket
			                               waitForAcceptFor: 10
			                               ifTimedOut: [ nil ] ].
	                 self addConnection: (self newConnection: bindSocket).
	                 bindSocket := nil ] repeat ]
		                 forkAt: Processor lowIOPriority
		                 named: 'PharoLinkServer listenProcess'
	"self preventTestForkedPDestroyServer"
]

{ #category : #'start-stop' }
PharoLinkServer >> stop [
	"Stop the receiver"

	listenProcess ifNotNil: #terminate.
	listenProcess := nil.
	connections do: #stop.
	connections removeAll.
	serverSocket  ifNotNil: #closeAndDestroy.
	serverSocket := nil.
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	^ self announcer unsubscribe: anObject
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> weak [
	"announcer weak subscribe: foo"

	^ self announcer weak
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> when: anAnnouncementClass do: aValuable [
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that ushc method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."

		^ self announcer when: anAnnouncementClass do: aValuable
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> when: anAnnouncementClass do: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ (self when: anAnnouncementClass do: aValuable) subscriber: aSubscriber; yourself.
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> when: anAnnouncementClass doOnce: aValuable for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"

	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> when: anAnnouncementClass send: aSelector to: anObject [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"

		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]

{ #category : #'announcer - subscription' }
PharoLinkServer >> when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber [
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber.
]
