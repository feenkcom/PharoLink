Class {
	#name : #PharoLinkProxyObject,
	#superclass : #LanguageLinkProxyObject,
	#category : 'PharoLink-Pharo-Platform'
}

{ #category : #'instance creation' }
PharoLinkProxyObject class >> remoteClass: remoteClassName name: registryId 	application: aLLApplication [
	| proxyClass |

	proxyClass := self allSubclasses
		detect: [ :each | each remoteClassName = remoteClassName ]
		ifNone: 
			[ (remoteClassName endsWith: ' class')
				ifTrue: [ PlpoClass ]
				ifFalse: [ self ] ].

	^ proxyClass new
		remoteClass: remoteClassName;
		name: registryId;
		application: aLLApplication
]

{ #category : #accessing }
PharoLinkProxyObject class >> remoteClassName [

	^ self subclassResponsibility 
]
