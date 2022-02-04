"
PharoLinkPortAllocator is a temporary hack to get a (hopefully) unique and unused port number.

It is just a random number generator between 10000 and 20000.

But we can't use the default Pharo PRNG since it often hits the same value, often on the first attempt.
"
Class {
	#name : #PharoLinkPortAllocator,
	#superclass : #Object,
	#category : #'PharoLink-Server'
}

{ #category : #accessing }
PharoLinkPortAllocator class >> next [

	^ '/dev/urandom' asFileReference binaryReadStreamDo:
		[ :stream | (stream next: 8) asInteger \\ 10000 + 10000 ]
]
