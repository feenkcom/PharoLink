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
	self assert: obj class equals: LanguageLinkProxyObject.
	self assert: obj remoteClass equals: 'PharoLinkRegistry'.
	cf := application newCommandFactory.
	cf << ('llCommand registry resolve: ', obj id printString).
	self assert: cf sendAndWait equals: obj
]

{ #category : #tests }
PharoLinkObjectTest >> testSimpleProxy [
	| obj hasId |

	obj := application newCommandFactory
		sendAndWait: 'llCommand registry'.
	self assert: obj class equals: LanguageLinkProxyObject.
	self assert: obj remoteClass equals: 'PharoLinkRegistry'.
	hasId := application newCommandFactory
			sendAndWait: 'llCommand registry includesId: 0'.
	self deny: hasId.
	hasId := application newCommandFactory 
		sendAndWait: 'llCommand registry includesId: ', obj id printString.
	self assert: hasId.
]
