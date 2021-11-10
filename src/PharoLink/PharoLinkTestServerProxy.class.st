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
		  updateWhen: PharoLinkTestCaseEndAnnouncement in: [ announcer ];
		  items: [ #( #failures #errors #skipped #passed ) ];
		  itemText: [ :anItem | 
			  anItem isSymbol
				  ifTrue: [ 
					  '{1} ({2})' format: { 
								  anItem.
								  (result perform: anItem) size } ]
				  ifFalse: [ anItem ] ];
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
PharoLinkTestServerProxy >> run: aSuiteString [

	| message promise commandFactory |
	events := OrderedDictionary new.
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
		           stream
			           nextPutAll: '| object block |
						object := ';
			           nextPutAll: aSuiteString;
			           nextPutAll: '.
						block := [ :e | self run: e notifier: ';
			           nextPutAll: observer pharoLinkFormattedCode;
			           nextPutAll: ' ].
						block value: object.
						true' ].
	promise := commandFactory send: message.
	^ promise
]
