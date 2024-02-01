"
A PharoLinkException holds the basic information of an exception in an easily serialisable format.
"
Class {
	#name : #PharoLinkException,
	#superclass : #Object,
	#instVars : [
		'exceptionClassName',
		'exceptionMessageText',
		'exceptionTrace'
	],
	#category : #'PharoLink-Test-Runner'
}

{ #category : #'instance creation' }
PharoLinkException class >> from: anException [

	^ self new
		exceptionClassName: anException class name;
		exceptionMessageText: anException messageText;
		exceptionTrace: anException stackString.
]

{ #category : #'instance creation' }
PharoLinkException class >> from: anException trace: aString [

	^ self new
		exceptionClassName: anException class name;
		exceptionMessageText: anException messageText;
		exceptionTrace: aString.
]

{ #category : #lejsonv4 }
PharoLinkException class >> leJsonV4Name [

	^ #pharoLinkException
]

{ #category : #accessing }
PharoLinkException >> exceptionClassName [
	^ exceptionClassName
]

{ #category : #accessing }
PharoLinkException >> exceptionClassName: anObject [
	exceptionClassName := anObject
]

{ #category : #accessing }
PharoLinkException >> exceptionMessageText [
	^ exceptionMessageText
]

{ #category : #accessing }
PharoLinkException >> exceptionMessageText: anObject [
	exceptionMessageText := anObject
]

{ #category : #accessing }
PharoLinkException >> exceptionTrace [
	^ exceptionTrace
]

{ #category : #accessing }
PharoLinkException >> exceptionTrace: anObject [
	exceptionTrace := anObject
]
