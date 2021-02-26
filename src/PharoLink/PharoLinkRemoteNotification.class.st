Class {
	#name : #PharoLinkRemoteNotification,
	#superclass : #Notification,
	#instVars : [
		'promise'
	],
	#category : #'PharoLink-ErrorHandling'
}

{ #category : #accessing }
PharoLinkRemoteNotification >> promise [
	^ promise
]

{ #category : #accessing }
PharoLinkRemoteNotification >> promise: anObject [
	promise := anObject
]
