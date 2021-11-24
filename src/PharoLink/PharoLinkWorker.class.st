Class {
	#name : #PharoLinkWorker,
	#superclass : #PharoLinkApplication,
	#category : #'PharoLink-Worker'
}

{ #category : #accessing }
PharoLinkWorker class >> commandLine [

	<commandline>
	| application |
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
				                  serverSocketAddress:
					                  (LanguageLinkSocketAddress from:
							                   serverSocketAddress);
				                  yourself).
		  StringSignal emit: 'Running'.
		  application start.
		  args
			  at: #taskPollForever
			  ifPresent: [ application taskPollForever ] ]
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
PharoLinkWorker >> do: aBlockString with: anObject [

	| message promise |
	message := String streamContents: [ :stream | 
		           stream nextPutAll: '
						object := LanguageLinkUtils base64Decode: '''.
		           LanguageLinkUtils base64Encode: anObject to: stream.
		           stream
			           nextPutAll: ''' readStream.
						block := ';
			           nextPutAll: aBlockString;
			           nextPutAll: '.
						result := String streamContents: [ :stream |
							LanguageLinkUtils base64Encode: (block value: object) to: stream ].
						result' ].
	promise := self newCommandFactory send: message.
	promise transformBlock: [ :r | 
		LanguageLinkUtils base64Decode: r readStream ].
	^ promise waitForValue
]

{ #category : #accessing }
PharoLinkWorker >> taskDone: aTask with: anObject [

	StringSignal emit: ('done {1} with {2}' format: { 
				 aTask.
				 anObject }).
	^ self
		  do: '[ :e | scheduler taskDone: e first with: e second. true ]'
		  with: { 
				  aTask.
				  anObject }
]

{ #category : #accessing }
PharoLinkWorker >> taskFailed: aTask with: anError [

	StringSignal emit: ('failed {1} with {2}' format: { 
				 aTask.
				 anError }).
	^ self
		  do: '[ :e | scheduler taskFailed: e first with: e second. true ]'
		  with: { 
				  aTask.
				  anError asString }
]

{ #category : #accessing }
PharoLinkWorker >> taskPoll [

	^ self do: '[ :e | scheduler taskPoll ]' with: nil
]

{ #category : #accessing }
PharoLinkWorker >> taskPollForever [

	[ 
	| task result error |
	task := self taskPoll.
	StringSignal emit: ('polled {1}' format: { task }).
	[ result := self taskRun: task source ]
		on: Error
		do: [ :e | 
			e freeze.
			error := e ].
	error
		ifNil: [ self taskDone: task with: result ]
		ifNotNil: [ self taskFailed: task with: error ] ] repeat
]

{ #category : #accessing }
PharoLinkWorker >> taskRun: aString [

	StringSignal emit: ('run {1}' format: { aString }).
	^ self class compiler
		  source: aString;
		  evaluate
]
