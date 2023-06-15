Class {
	#name : #PharoLinkServerConnectionConnectedAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'connection'
	],
	#category : #'PharoLink-Server'
}

{ #category : #'instance creation' }
PharoLinkServerConnectionConnectedAnnouncement class >> connection: aPharoLinkServerConnection [

	^ self new connection: aPharoLinkServerConnection
]

{ #category : #accessing }
PharoLinkServerConnectionConnectedAnnouncement >> connection [

	^ connection
]

{ #category : #accessing }
PharoLinkServerConnectionConnectedAnnouncement >> connection: anObject [

	connection := anObject
]
