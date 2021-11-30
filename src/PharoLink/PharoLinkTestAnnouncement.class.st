Class {
	#name : #PharoLinkTestAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'timestamp'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestAnnouncement class >> isAbstract [

	^ self == PharoLinkTestAnnouncement
]

{ #category : #accessing }
PharoLinkTestAnnouncement class >> leJsonV4AddMappingsTo: aJsonMapping [

	aJsonMapping
		mapProperty: #timestamp
		getter: [ :object | object timestamp ]
		setter: [ :object :value | self error: 'Cannot set it' ]
]

{ #category : #accessing }
PharoLinkTestAnnouncement >> initialize [

	super initialize.
	timestamp := DateAndTime now
]

{ #category : #accessing }
PharoLinkTestAnnouncement >> timestamp [

	^ timestamp
]
