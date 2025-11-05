Class {
	#name : #PharoLinkServerConnectionDisconnectedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'connection'
	],
	#category : 'PharoLink-Server'
}

{ #category : #'instance creation' }
PharoLinkServerConnectionDisconnectedAnnouncement class >> connection: aPharoLinkServerConnection [

	^ self new connection: aPharoLinkServerConnection
]

{ #category : #accessing }
PharoLinkServerConnectionDisconnectedAnnouncement >> connection [

	^ connection
]

{ #category : #accessing }
PharoLinkServerConnectionDisconnectedAnnouncement >> connection: anObject [

	connection := anObject
]
