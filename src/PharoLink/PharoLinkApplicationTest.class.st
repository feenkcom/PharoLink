Class {
	#name : #PharoLinkApplicationTest,
	#superclass : #PharoLinkTest,
	#category : #'PharoLink-Tests'
}

{ #category : #accessing }
PharoLinkApplicationTest class >> appResource [

	^ PharoLinkApplicationTestResource 
]

{ #category : #accessing }
PharoLinkApplicationTest class >> resources [
	^ super resources , { PharoLinkApplicationTestResource. }
]

{ #category : #running }
PharoLinkApplicationTest >> setUp [ 
	"Subclasses of JSLinkApplicationTest require a running server"

	super setUp.
	application := self class appResource current application.
	commandFactory := self class appResource current commandFactory.
]
