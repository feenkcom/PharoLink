Class {
	#name : #PharoLinkWorker,
	#superclass : #PharoLinkApplication,
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorker class >> commandLine [

	<commandline>
	| application |
	self flag: 'TODO allow more than just port'.
	^ self commandLineCommand meaning: [ :args | 
		  | logger serverSocketAddress |
		  args
			  at: #help ifPresent: [ :help | 
				  help value.
				  help context exitSuccess ];
			  at: #log ifPresent: [ 
				  SignalLogger resetAllInstances.
				  logger := RestartingStreamLogger stdout.
				  logger start ].
		  serverSocketAddress := (args at: #serverSocketAddress) value.
		  StringSignal emit:
			  'Connect server socket address: ' , serverSocketAddress.
		  application := self newWith: (self defaultSettings
				                  serverProcessClass: LanguageLinkManualProcess;
				                  serverSocketAddress: (LanguageLinkSocketAddress
						                   ipOrName: 'localhost'
						                   port: serverSocketAddress asInteger);
				                  yourself).
		  StringSignal emit: 'Running'.
		  application start.
		  args
			  at: #taskPollForever
			  ifPresent: [ application taskPollForever ].
		  "Wait until the process is killed"
		  Semaphore new wait ]
]

{ #category : #accessing }
PharoLinkWorker class >> commandLineCommand [

	^ (ClapCommand id: 'pharoLinkWorker')
		  description: 'Run the PharoLink worker';
		  add: ClapFlag forHelp;
		  add: ((ClapFlag id: 'log') description: 'Enable logging to stdout');
		  add: ((ClapFlag id: 'taskPollForever') description: 'Poll tasks forever');
		  add: ((ClapPositional id: 'serverSocketAddress') description:
					   'The server socket address on which to connect for requests');
		  yourself
]

{ #category : #accessing }
PharoLinkWorker >> taskDone: aString with: anObject [

	| message promise |
	message := String streamContents: [ :stream | 
		           stream nextPutAll: '| object |
						object := LanguageLinkUtils base64Decode: '''.
		           LanguageLinkUtils base64Encode: anObject to: stream.
		           stream
			           nextPutAll: ''' readStream.
						scheduler taskDone: ''';
			           nextPutAll: aString;
			           nextPutAll: ''' with: object.
						true' ].
	promise := self newCommandFactory send: message.
	^ promise waitForValue
]

{ #category : #accessing }
PharoLinkWorker >> taskFailed: aString with: anError [

	| message promise |
	message := String streamContents: [ :stream | 
		           stream
			           nextPutAll: 'scheduler taskFailed: ''';
			           nextPutAll: aString;
			           nextPutAll: ''' with: '''.
		           anError printOn: stream.
		           stream nextPutAll: '''.
						true' ].
	promise := self newCommandFactory send: message.
	^ promise waitForValue
]

{ #category : #accessing }
PharoLinkWorker >> taskPoll [

	^ self newCommandFactory sendAndWait: 'scheduler taskPoll'
]

{ #category : #accessing }
PharoLinkWorker >> taskPollForever [

	[ 
	| task result error |
	task := self taskPoll.
	[ result := self taskRun: (task at: #source) ]
		on: Error
		do: [ :e | 
			e freeze.
			error := e ].
	error
		ifNil: [ self taskDone: (task at: #id) with: result ]
		ifNotNil: [ self taskFailed: (task at: #id) with: error ] ] repeat
]

{ #category : #accessing }
PharoLinkWorker >> taskRun: aString [

	^ self class compiler
		  source: aString;
		  evaluate
]
