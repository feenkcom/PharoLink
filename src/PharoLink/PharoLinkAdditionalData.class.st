Class {
	#name : #PharoLinkAdditionalData,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : 'PharoLink-Test-Runner'
}

{ #category : #lejsonv4 }
PharoLinkAdditionalData class >> leJsonV4AttributeMapping [
	"Answer the Array of attribute to store keys.
	Subclasses should override this with their attributes."

	^ {
		#properties -> #properties.
	 }
]

{ #category : #lejsonv4 }
PharoLinkAdditionalData class >> leJsonV4Name [

	^ #pharoLinkAdditionalData
]

{ #category : #accessing }
PharoLinkAdditionalData >> at: aKey put: anObject [

	^ properties at: aKey put: anObject
]

{ #category : #ui }
PharoLinkAdditionalData >> gtLoopAnalysisFor: aView [
	<gtView>
	
	(properties includesKey: #loopAnalysis) ifFalse: [ ^ aView empty ].
	^ aView text
		title: 'Loop Analysis';
		priority: 20;
		text: [ properties at: #loopAnalysis ]
]

{ #category : #initialize }
PharoLinkAdditionalData >> initialize [

	super initialize.
	properties := Dictionary new.
]

{ #category : #testing }
PharoLinkAdditionalData >> isEmpty [

	^ properties isEmpty
]

{ #category : #accessing }
PharoLinkAdditionalData >> properties [
	^ properties
]

{ #category : #accessing }
PharoLinkAdditionalData >> properties: anObject [
	properties := anObject
]
