Class {
	#name : #PharoLinkExceptionSerializedData,
	#superclass : #Object,
	#instVars : [
		'exception',
		'stackString',
		'additionalData'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #'instance creation' }
PharoLinkExceptionSerializedData class >> fromException: anException [ 
	^ self new 
		initializeFromException: anException 
]

{ #category : #'instance creation' }
PharoLinkExceptionSerializedData class >> fromException: anException stackString: aStackString additionalData: anAdditonalData [ ^ self new 
		initializeFromException: anException 
		stackString: aStackString 
		additionalData: anAdditonalData
]

{ #category : #'as yet unclassified' }
PharoLinkExceptionSerializedData >> additionalData [
	^ additionalData
]

{ #category : #'as yet unclassified' }
PharoLinkExceptionSerializedData >> exception [
	^ exception
]

{ #category : #initialization }
PharoLinkExceptionSerializedData >> initializeFromException: anException [ 
	exception := anException.
	stackString :=  anException stackString.
	additionalData := anException pharoLinkAdditionalData.
]

{ #category : #initialization }
PharoLinkExceptionSerializedData >> initializeFromException: anException stackString: aStackString additionalData: anAdditonalData [ 
	exception := anException.
	stackString := aStackString.
	additionalData := anAdditonalData 
]

{ #category : #'as yet unclassified' }
PharoLinkExceptionSerializedData >> stackString [
	^ stackString
]
