Class {
	#name : #GtPlBareProxy,
	#superclass : #GtLlBareProxy,
	#category : 'PharoLink-Core'
}

{ #category : #'instance creation' }
GtPlBareProxy class >> forProxyObject: aProxyObject [
	| proxyClass |

	proxyClass := self subclassForRemoteClass: aProxyObject remoteClass.
	^ proxyClass new proxyObject: aProxyObject
]

{ #category : #private }
GtPlBareProxy class >> leProxyTypeForPlaygroundPage [
	^ GtPlBareProxy
]

{ #category : #private }
GtPlBareProxy class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | self remoteClassName = aSymbol ]
]

{ #category : #private }
GtPlBareProxy class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ nil
]

{ #category : #private }
GtPlBareProxy class >> subclassForRemoteClass: aSymbol [
	"Answer the subclass that represents the supplied class name"

	^ self subclasses
		detect: [ :each | each remoteClassMatcher value: aSymbol ]
		ifNone: [ self ].

]
