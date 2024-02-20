Class {
	#name : #LanguageLinkStartStopAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'subject'
	],
	#category : #'PharoLink-Announcements'
}

{ #category : #accessing }
LanguageLinkStartStopAnnouncement >> subject [
	^ subject
]

{ #category : #accessing }
LanguageLinkStartStopAnnouncement >> subject: anObject [
	subject := anObject
]
