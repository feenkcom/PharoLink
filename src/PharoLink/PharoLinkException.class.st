"
A PharoLinkException holds the basic information of an exception in an easily serialisable format.
"
Class {
	#name : #PharoLinkException,
	#superclass : #Object,
	#instVars : [
		'exceptionClassName',
		'exceptionMessageText',
		'exceptionTrace',
		'exceptionAdditionalData'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #'instance creation' }
PharoLinkException class >> from: anException [

	^ self new
		exceptionClassName: anException class name;
		exceptionMessageText: anException messageText;
		exceptionTrace: anException stackString;
		exceptionAdditionalData: anException pharoLinkAdditionalData.
]

{ #category : #'instance creation' }
PharoLinkException class >> from: anException trace: aString [

	^ self new
		exceptionClassName: anException class name;
		exceptionMessageText: anException messageText;
		exceptionTrace: aString;
		exceptionAdditionalData: anException pharoLinkAdditionalData.
]

{ #category : #lejsonv4 }
PharoLinkException class >> leJsonV4Name [

	^ #pharoLinkException
]

{ #category : #accessing }
PharoLinkException >> exceptionAdditionalData [
	^ exceptionAdditionalData
]

{ #category : #accessing }
PharoLinkException >> exceptionAdditionalData: anObject [

	exceptionAdditionalData := anObject
]

{ #category : #accessing }
PharoLinkException >> exceptionClass [

	^ self class environment at: exceptionClassName
]

{ #category : #accessing }
PharoLinkException >> exceptionClassName [
	^ exceptionClassName
]

{ #category : #accessing }
PharoLinkException >> exceptionClassName: anObject [
	exceptionClassName := anObject
]

{ #category : #accessing }
PharoLinkException >> exceptionMessageText [
	^ exceptionMessageText
]

{ #category : #accessing }
PharoLinkException >> exceptionMessageText: anObject [
	exceptionMessageText := anObject
]

{ #category : #accessing }
PharoLinkException >> exceptionTrace [
	^ exceptionTrace
]

{ #category : #accessing }
PharoLinkException >> exceptionTrace: anObject [
	exceptionTrace := anObject
]

{ #category : #accessing }
PharoLinkException >> gtDisplayOn: aStream [

	exceptionMessageText
		ifNil: [ super gtDisplayOn: aStream ]
		ifNotNil: [ aStream << exceptionMessageText ]
]

{ #category : #ui }
PharoLinkException >> gtSummaryFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item key ];
		  column: #Value text: [ :item | item value ];
		  actionUpdateButton
]

{ #category : #ui }
PharoLinkException >> gtTraceFor: aView [
	<gtView>

	exceptionTrace ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Trace';
		priority: 15;
		text: [ exceptionTrace ];
		styler: GtTraceStyler new;
		aptitude: BrGlamorousCodeEditorAptitude
]

{ #category : #ui }
PharoLinkException >> summaryAttributes [
	"Answer a collection of key/value attributes that can simply be listed as a summary of the receiver"

	^ OrderedCollection new
		add: 'Exception Class:' -> (exceptionClassName ifNil: [ '<unknown>' ] ifNotNil: [ exceptionClassName ]);
		add: 'Message:' -> (exceptionMessageText ifNil: [ '<unknown>' ] ifNotNil: [ exceptionMessageText ]);
		yourself.
]
