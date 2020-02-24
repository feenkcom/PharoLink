Class {
	#name : #JSLinkAbstractMessage,
	#superclass : #Object,
	#category : #'PharoLink-Platform-Messages'
}

{ #category : #'instance creation' }
JSLinkAbstractMessage class >> forApplication: aLLApplication [

	^ self new initializeWith: aLLApplication
]

{ #category : #testing }
JSLinkAbstractMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractMessage class >> type [
	self subclassResponsibility
]

{ #category : #initialization }
JSLinkAbstractMessage >> initializeWith: aLLApplication [
	"Subclasses can override this for application specific initialization"
]

{ #category : #testing }
JSLinkAbstractMessage >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ self class isReverseMessage
]

{ #category : #accessing }
JSLinkAbstractMessage >> type [
	^ self class type
]
