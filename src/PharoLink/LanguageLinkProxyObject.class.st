Class {
	#name : #LanguageLinkProxyObject,
	#superclass : #Object,
	#instVars : [
		'application',
		'remoteClass',
		'name'
	],
	#category : #'PharoLink-Core'
}

{ #category : #adding }
LanguageLinkProxyObject >> addPlaygroundBindingsTo: aCommandFactory [

	aCommandFactory addBinding: (PharoLinkBinding 
		key: 'self' wrap: self)
]

{ #category : #accessing }
LanguageLinkProxyObject >> application [
	^ application
]

{ #category : #accessing }
LanguageLinkProxyObject >> application: anObject [
	application := anObject
]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> declarativeViews [
	"Answer the views for the receiver"
	| viewSelectors rawViews viewDictionary |

	viewSelectors := self newCommandFactory
				<< 'self gtDeclarativeViewSelectors';
				sendAndWait.
	rawViews := viewSelectors collect: [ :viewSelector |
		viewDictionary := self newCommandFactory
				<< ('(self ', viewSelector, ' GtPhlowEmptyView new) asGtDeclarativeView asDictionaryForExport');
				sendAndWait.
		((GtDeclarativeView fromDictionary: viewDictionary)
					accessor: self;
					methodName: viewSelector;
					yourself) ].
	^ rawViews
]

{ #category : #'as yet unclassified' }
LanguageLinkProxyObject >> evaluateSourceSequence: aString [ [
	| cf |

	cf := self newCommandFactory.
	^ cf 
		<< aString;
		sendAndWait.
]

]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> gtLocalViewsFor: aView inContext: aContext [
	| title resultingView |

	title := String streamContents: [ :stream |
				stream
					<< 'Proxy to a(n): ';
					<< (remoteClass ifNil: [ '<None>' ]) ].
	resultingView := ((aView composite
		views: (self gtViewsInContext: aContext))
		labelled: title).
	^ resultingView
]

{ #category : #ui }
LanguageLinkProxyObject >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		priority: 10;
		text: [ '' asRopedText attributesBuilder attribute: (BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler) ];
		actionButtonIcon: BrGlamorousIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				result := self evaluateSourceSequence: statements.
				aButton phlow spawnObject: result ].

]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> gtProxyFor: aView [
	<gtProxy>

	^(self gtRawFor: aView)
		title: 'Proxy' translated;
		priority: 10000.
]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> gtProxyViewsFor: aView [
	<gtView>
	^ aView list
		title: 'Proxy views' translated;
		priority: 10001;
		items: [ 	self declarativeViews ];
		itemFormat: [ :aViewAccessor | aViewAccessor title ];
		send: [ :aDeclarativeView | aDeclarativeView ]
]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> gtViewsFor: aView inContext: aContext [
	"Add the declarative views from the inspectors object to the inspectors views"

	| resultingView inspectorViews |

	resultingView := self gtLocalViewsFor: aView inContext: aContext.
	inspectorViews := resultingView originalView views.

	"Add the explicitly declarative views from the inspected object"
	inspectorViews addAll: (self viewsFor: aView).

	"Re-sort by priority"
	inspectorViews := inspectorViews sorted: [ :a :b | a priority < b priority ].
	resultingView originalView views: inspectorViews.
	^resultingView
]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> gtViewsInContext: aContext [
	"This collects all views for the current object.
	For a proxy we just want the Raw view renamed as 'Proxy'"
	| emptyView |

	emptyView := GtPhlowEmptyView new.
	^ OrderedCollection 
		with: (self gtProxyFor: emptyView)
		with: (self gtProxyViewsFor: emptyView)
]

{ #category : #accessing }
LanguageLinkProxyObject >> id [ 

	^ name
]

{ #category : #accessing }
LanguageLinkProxyObject >> name [
	^ name
]

{ #category : #accessing }
LanguageLinkProxyObject >> name: anObject [
	name := anObject
]

{ #category : #serialization }
LanguageLinkProxyObject >> neoJsonOn: aWriter [

	{ '__class__' -> remoteClass.
	'__registryid__' -> name. } asDictionary
		neoJsonOn: aWriter
]

{ #category : #'instance creation' }
LanguageLinkProxyObject >> newCommandFactory [
	| cf |

	cf := self application newCommandFactory.
	self addPlaygroundBindingsTo: cf.
	^ cf
]

{ #category : #accessing }
LanguageLinkProxyObject >> pharoLinkFormattedCode [ 

	^ 'llCommand registry resolve: ', name printString
]

{ #category : #accessing }
LanguageLinkProxyObject >> remoteClass [
	^ remoteClass
]

{ #category : #accessing }
LanguageLinkProxyObject >> remoteClass: anObject [
	remoteClass := anObject
]

{ #category : #'gt inspector' }
LanguageLinkProxyObject >> viewsFor: aView [
	"Should be all views, but just get Raw and Print views for now"

	^ self declarativeViews collect: [ :declarativeView | declarativeView viewFor: aView ].

]
