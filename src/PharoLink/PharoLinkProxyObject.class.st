Class {
	#name : #PharoLinkProxyObject,
	#superclass : #LanguageLinkProxyObject,
	#category : #'PharoLink-Pharo-Platform'
}

{ #category : #'instance creation' }
PharoLinkProxyObject class >> remoteClass: remoteClassName name: registryId 	application: aLLApplication [
	| proxyClass |

	proxyClass := self subclasses
		detect: [ :each | each remoteClassName = remoteClassName ]
		ifNone: [ self ].

	^ proxyClass new
		remoteClass: remoteClassName;
		name: registryId;
		application: aLLApplication
]

{ #category : #accessing }
PharoLinkProxyObject class >> remoteClassName [

	^ self subclassResponsibility 
]
