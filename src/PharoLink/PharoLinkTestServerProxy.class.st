Class {
	#name : #PharoLinkTestServerProxy,
	#superclass : #PharoLinkProxyObject,
	#instVars : [
		'observer',
		'announcer',
		'result',
		'events',
		'numberOfTests'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestServerProxy class >> remoteClassName [

	^ #PharoLinkTestServer
]

{ #category : #accessing }
PharoLinkTestServerProxy >> announcer [

	^ announcer
]

{ #category : #ui }
PharoLinkTestServerProxy >> gtEventsFor: aView [

	<gtView>
	^ aView explicit
		  title: 'Events';
		  priority: 0;
		  updateWhen: PharoLinkTestAnnouncement in: [ announcer ];
		  stencil: [ 
			  | container |
			  container := BlElement new
				               layout: BlFlowLayout horizontal;
				               constraintsDo: [ :c | 
					               c horizontal matchParent.
					               c vertical matchParent ];
				               yourself.
			  events keysAndValuesDo: [ :h :s | 
				  | color |
				  color := s size = 1
					           ifTrue: [ s anyOne color ]
					           ifFalse: [ (s detect: #isEnd) color ].
				  container addChild: (BlElement new
						   size: 15 @ 15;
						   margin: (BlInsets all: 2);
						   background: color;
						   yourself) ].
			  events size + 1 to: numberOfTests do: [ :i | 
				  container addChild: (BlElement new
						   size: 15 @ 15;
						   margin: (BlInsets all: 2);
						   background: Color gray;
						   yourself) ].
			  container ]
]

{ #category : #ui }
PharoLinkTestServerProxy >> gtResultsFor: aView [

	<gtView>
	^ aView tree
		  title: 'Results';
		  priority: 1;
		  updateWhen: TestCaseAnnouncement in: [ announcer ];
		  items: [ #( #passed #failures #errors #skipped ) ];
		  children: [ :anItem | 
			  anItem isSymbol
				  ifTrue: [ result perform: anItem ]
				  ifFalse: [ #(  ) ] ];
		  expandAll;
		  send: [ :anItem | 
			  anItem isSymbol
				  ifTrue: [ result perform: anItem ]
				  ifFalse: [ anItem ] ]
]

{ #category : #accessing }
PharoLinkTestServerProxy >> initialize [

	super initialize.
	announcer := Announcer new.
	events := OrderedDictionary new.
	result := TestResult new.
	numberOfTests := 0.
]

{ #category : #accessing }
PharoLinkTestServerProxy >> run: aSuite [

	| message promise commandFactory |
	events := OrderedDictionary new.
	numberOfTests := SUnitTestsCounter new
		                 visit: aSuite;
		                 count.
	commandFactory := self newCommandFactory.
	observer := commandFactory observerFromCallback: [ :e | 
		            | buffer |
		            buffer := LanguageLinkUtils base64Decode: e readStream.
		            buffer do: [ :event | 
			            events
				            at: event hash
				            ifPresent: [ :set | set add: event ]
				            ifAbsentPut: [ IdentitySet with: event ].
			            announcer announce: event ].
		            0 ].
	message := String streamContents: [ :stream | 
		           stream nextPutAll: '
						object := LanguageLinkUtils base64Decode: '''.
		           LanguageLinkUtils base64Encode: aSuite to: stream.
		           stream
			           nextPutAll: ''' readStream.
						block := [ :e | self run: e notifier: ';
			           nextPutAll: observer pharoLinkFormattedCode;
			           nextPutAll: ' ].
						result := String streamContents: [ :stream |
							LanguageLinkUtils base64Encode: (block value: object) to: stream ].
						result' ].
	promise := commandFactory send: message.
	promise transformBlock: [ :r | 
		result := LanguageLinkUtils base64Decode: r readStream ].
	^ promise
]
