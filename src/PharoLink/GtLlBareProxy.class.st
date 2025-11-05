Class {
	#name : #GtLlBareProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'proxyObject'
	],
	#category : 'PharoLink-Core'
}

{ #category : #'instance creation' }
GtLlBareProxy class >> forProxyObject: aServiceClient [
	^ self new
		proxyObject: aServiceClient
]

{ #category : #'gt - coder' }
GtLlBareProxy class >> gtSlotNamed: aName ifFound: foundBlock ifNone: exceptionBlock [
	"The proxy hides its only slot (proxyObject), so just evaluate exceptionBlock"

	^ exceptionBlock value
]

{ #category : #'gt - coder' }
GtLlBareProxy class >> gtSlotNames [
	"Answer the slot names to be bound by GtPharoSourceCoderViewModel.
	Answer an empty Array since we don't want to see the proxy object itself."

	^ #()
]

{ #category : #comparing }
GtLlBareProxy >> = anObject [
	"If the receiver has a serviceClient, delegate equality to the serviceClient, otherwise use the identity of the receiver"

	^ proxyObject 
		ifNil: [ self == anObject ]
		ifNotNil: [ anObject = proxyObject ]
]

{ #category : #transformation }
GtLlBareProxy >> asGtBareProxyObject [
	^ self
]

{ #category : #transformation }
GtLlBareProxy >> asGtProxyObject [
	^ proxyObject
]

{ #category : #'gt inspector' }
GtLlBareProxy >> asLink [
	"This is needed in the proxy object, as LinkedLists used by the inspector call #asLink on the objects that they add."

	^ ValueLink value: self
]

{ #category : #'reflective operations' }
GtLlBareProxy >> doesNotUnderstand: aMessage [ 
	"In case the proxy has no remote client or the client is not logged in
	do not propagate the message to the remote object. If the return value 
	is not a primitive type I convert it to a bare proxy."
	
	^ self isProxyObjectActive 
		ifFalse: [ super doesNotUnderstand: aMessage  ]
		ifTrue: [ self performRemotely: aMessage selector withArguments: aMessage arguments ]
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (proxyObject gtRemoteSideInspectorTool
			name: 'Remote';
			withLabelAndIconAptitude);
		addTool: (super gtDefaultInspectorTool
			name: 'Proxy';
			withLabelAndIconAptitude)
]

{ #category : #printing }
GtLlBareProxy >> gtDisplayOn: aStream [
	proxyObject ifNil: [ 
		aStream << 'Bare Proxy on: <not configured>'.
		^ self ].
	
	proxyObject isProxyObjectActive ifFalse: [ 
		aStream << 'Bare Proxy on: <not connected>'.
		^ self ].
	
	aStream 
		<< 'Bare Proxy on: ';
		<< ([proxyObject proxyPerform: #gtDisplayString]
				on: Error 
				do: [ :e | 'Error printing'  ])
]

{ #category : #printing }
GtLlBareProxy >> gtDisplayText [
	^ (String streamContents: [ :aStream |
		self gtDisplayOn:  aStream  ]) asRopedText
]

{ #category : #printing }
GtLlBareProxy >> gtInspectorTitleString [
	| limitedString limit |
	limit := 1000.
	limitedString := String 	
		streamContents: [ :s | self gtInspectorTitleStringOn: s ] 
		limitedTo: limit.
	limitedString size < limit ifTrue: [^ limitedString].
	^ limitedString , ' ...'
]

{ #category : #printing }
GtLlBareProxy >> gtInspectorTitleStringOn: aStream [
	self gtDisplayOn: aStream
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtPrintFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'Print';
		priority: 110;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self gtDisplayString asRopedText ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtRawFor: aView [
	"Provide a basic view of the proxy object.
	This is simpler than the standard Raw view, but avoids many methods that are implemented in Object"

	<gtView>
	^ aView columnedList
		title: 'Raw';
		priority: 100;
		items: [ {{#self.
					self}.
				{#proxyObject.
					proxyObject}} ];
		column: #Icon
			icon: [ :item | item second class iconNamed: item second class systemIconName ]
			width: 36;
		column: #Variable text: [ :item | item first ];
		column: #Value
			text: [ :item | 
				item first = #self
					ifTrue: [ self class name ]
					ifFalse: [ [ item second printString ]
							on: Error , Halt
							do: [ :ex | ex printString asRopedText foreground: Color red ] ] ];
		send: [ :item | item second ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtRemoteViewSpecificationsFor: aView [
	<gtView>
	
	proxyObject ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Remote view specifications';
		priority: 10001;
		object: [ proxyObject ];
		view: #gtRemoteViewSpecificationsFor:
]

{ #category : #comparing }
GtLlBareProxy >> hash [

	^ proxyObject 
		ifNil: [ self identityHash ]
		ifNotNil: [ proxyObject hash ]

]

{ #category : #pinning }
GtLlBareProxy >> isPinnedInMemory [
	"Copied from Object>>isPinnedInMemory"
	<primitive: 183 error: ec>
	^self primitiveFailed
]

{ #category : #testing }
GtLlBareProxy >> isProxyObjectActive [

	^ proxyObject 
		ifNil: [ false ] 
		ifNotNil: [ :aProxyObject | 
			aProxyObject application isRunning ] 
]

{ #category : #'actions - proxy' }
GtLlBareProxy >> performRemotely: aSelector withArguments: argumentsArray [
	| result |
	
	result := proxyObject 
		proxyPerform: aSelector 
		withPrimitiveArguments: argumentsArray.
	
	^ result asGtBareProxyObject
]

{ #category : #accessing }
GtLlBareProxy >> proxyObject [
	^ proxyObject 
]

{ #category : #accessing }
GtLlBareProxy >> proxyObject: aLlProxyObject [

	proxyObject ifNotNil: [ 
		Error signal: 'Cannot change the proxy object.' ].
	proxyObject := aLlProxyObject
]

{ #category : #'memory usage' }
GtLlBareProxy >> sizeInMemory [
	^ self class byteSizeOfInstance 
]
