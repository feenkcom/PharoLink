Class {
	#name : 'LanguageLinkAbstractMessage',
	#superclass : 'Object',
	#category : 'PharoLink-Platform-Messages'
}

{ #category : 'instance creation' }
LanguageLinkAbstractMessage class >> forApplication: aLLApplication [

	^ self new initializeWith: aLLApplication
]

{ #category : 'testing' }
LanguageLinkAbstractMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	self subclassResponsibility
]

{ #category : 'accessing' }
LanguageLinkAbstractMessage class >> type [
	self subclassResponsibility
]

{ #category : 'initialization' }
LanguageLinkAbstractMessage >> initializeWith: aLLApplication [
	"Subclasses can override this for application specific initialization"
]

{ #category : 'testing' }
LanguageLinkAbstractMessage >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ self class isReverseMessage
]

{ #category : 'accessing' }
LanguageLinkAbstractMessage >> type [
	^ self class type
]
