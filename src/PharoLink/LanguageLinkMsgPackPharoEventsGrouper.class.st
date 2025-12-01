Class {
	#name : #LanguageLinkMsgPackPharoEventsGrouper,
	#superclass : #GtBeaconEventsGrouper,
	#category : 'PharoLink-Logging'
}

{ #category : #accessing }
LanguageLinkMsgPackPharoEventsGrouper >> createDefaultEventsGroup [
	^ LanguageLinkMsgPackPharoBrokerEventsGroup new
]
