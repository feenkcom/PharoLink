Class {
	#name : 'LanguageLinkPharoWeakFinalizerTest',
	#superclass : 'LanguageLinkWeakFinalizerTest',
	#category : 'PharoLink-Pharo-Platform'
}

{ #category : 'running' }
LanguageLinkPharoWeakFinalizerTest >> triggerGC [
	Smalltalk garbageCollect.
	(Delay forMilliseconds: 100) wait.
	Smalltalk garbageCollect.
]

{ #category : 'running' }
LanguageLinkPharoWeakFinalizerTest >> weakRegistryClass [
	^ LanguageLinkPharoWeakRegistry
]
