Class {
	#name : 'PharoLinkRemoteNotification',
	#superclass : 'Notification',
	#instVars : [
		'promise'
	],
	#category : 'PharoLink-ErrorHandling'
}

{ #category : 'testing' }
PharoLinkRemoteNotification >> isPharoLinkNotification [
	"Answer a boolean indicating whether this exception is a PharoLink notification"

	^ true
]

{ #category : 'accessing' }
PharoLinkRemoteNotification >> promise [
	^ promise
]

{ #category : 'accessing' }
PharoLinkRemoteNotification >> promise: anObject [
	promise := anObject
]
