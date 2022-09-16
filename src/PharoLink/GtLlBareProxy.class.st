Class {
	#name : #GtLlBareProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'proxyObject'
	],
	#category : #'PharoLink-Core'
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

{ #category : #'reflective operations' }
GtLlBareProxy >> doesNotUnderstand: aMessage [ 
	"In case the proxy has no remote client or the client is not logged in
	do not propagate the message to the remote object. If the return value 
	is not a primitive type I convert it to a bare proxy."
	
	^ self isProxyObjectActive 
		ifFalse: [ super doesNotUnderstand: aMessage  ]
		ifTrue: [ self performRemotely: aMessage selector withArguments: aMessage arguments ]
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
	proxyObject ifNil: [ 
		aStream << 'a GtLlBareProxy'.
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

{ #category : #'gt inspector' }
GtLlBareProxy >> gtMetaFor: aView [
	<gtProxy>
	^ aView explicit
		title: 'Meta';
		priority: 200;
		stencil: [ (GtPharoBehaviorCoder forObject: self) asElement ]
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtProxyViewsFor: aView [
	<gtView>
	^ aView composite
		title: 'Proxy';
		priority: 10000;
		collectorDo: [ :aCollector |
			aCollector 
				pragmaName: #gtProxy;
				fromObject: self ]
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtRawFor: aView [
	"Provide a basic view of the proxy object.
	This is simpler than the standard Raw view, but avoids many methods that are implemented in Object"
	<gtProxy>

	^ aView columnedList
		title: 'Raw';
		priority: 100;
		items: [ {
			{ #self. self. }.
			{ #proxyObject. proxyObject. } } ];
		column: #Icon
			icon: [ :item | item second class systemIcon ]
			width: 36;
		column: #Variable text: [ :item | item first ];
		column: #Value text: [ :item | 
			item first = #self ifTrue:
				[ self class name ]
			ifFalse:
				[ [ item second printString ]
					on: Error, Halt
					do: [ :ex | ex printString asRopedText foreground: Color red ] ] ];
		send: [ :item | item second ];
		actionUpdateButton
]

{ #category : #'gt inspector' }
GtLlBareProxy >> gtViewsInContext: aContext [
	| proxyObjectViews collectedViews |
	"This collects all views for the current object, both local and remote."
	
	proxyObjectViews := proxyObject gtViewsInContext: aContext.
	proxyObjectViews := proxyObjectViews reject: [ :each |
		#(Proxy) includes: each title ].
	
	collectedViews := OrderedCollection new
		addAll: (super gtViewsInContext: aContext);
		addAll: proxyObjectViews;
		yourself.
	GtPhlowUtility sortByPriority: collectedViews.
	^ collectedViews
]

{ #category : #comparing }
GtLlBareProxy >> hash [

	^ proxyObject 
		ifNil: [ self identityHash ]
		ifNotNil: [ proxyObject hash ]

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

	^ proxyObject 
		proxyPerform: aSelector 
		withPrimitiveArguments: argumentsArray 
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
