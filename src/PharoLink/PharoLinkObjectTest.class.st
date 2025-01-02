"
It is possible there's a race condition in LanguageLinkRegistryFinalizer that means that the application is still flagged as running when in fact it has gone.  This causes the attempt to remove an object from the registry to fail, failing the test.  See {{gtMethod:LanguageLinkRegistryFinalizer>>#finalize}}.
"
Class {
	#name : #PharoLinkObjectTest,
	#superclass : #PharoLinkApplicationTest,
	#category : #'PharoLink-Tests'
}

{ #category : #tests }
PharoLinkObjectTest >> testProxyIdentity [
	| obj cf |

	cf := application newCommandFactory.
	cf << 'llCommand registry'.
	obj := cf sendAndWait.
	self assert: obj class equals: PharoLinkProxyObject.
	self assert: obj remoteClass equals: 'PharoLinkRegistry'.
	cf := application newCommandFactory.
	cf << ('llCommand registry resolve: ', obj proxyObjectId printString).
	self assert: cf sendAndWait equals: obj
]

{ #category : #tests }
PharoLinkObjectTest >> testSimpleProxy [
	| obj hasId |

	obj := application newCommandFactory
		sendAndWait: 'llCommand registry'.
	self assert: obj class equals: PharoLinkProxyObject.
	self assert: obj remoteClass equals: 'PharoLinkRegistry'.
	hasId := application newCommandFactory
			sendAndWait: 'llCommand registry includesId: 0'.
	self deny: hasId.
	hasId := application newCommandFactory 
		sendAndWait: 'llCommand registry includesId: ', obj proxyObjectId printString.
	self assert: hasId.
]
