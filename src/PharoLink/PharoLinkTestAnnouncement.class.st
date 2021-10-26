Class {
	#name : #PharoLinkTestAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'timestamp'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestAnnouncement >> initialize [

	super initialize.
	timestamp := DateAndTime now
]
