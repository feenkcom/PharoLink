Class {
	#name : 'LanguageLinkAbstractWeakRegistry',
	#superclass : 'Object',
	#category : 'PharoLink-Platform'
}

{ #category : 'registration' }
LanguageLinkAbstractWeakRegistry >> destroy [
	self subclassResponsibility
]

{ #category : 'registration' }
LanguageLinkAbstractWeakRegistry >> registerObject: anObject finalizer: finalizer [
	self subclassResponsibility
]
