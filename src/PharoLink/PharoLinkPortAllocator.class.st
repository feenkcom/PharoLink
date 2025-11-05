"
PharoLinkPortAllocator is a temporary hack to get a (hopefully) unique and unused port number.

It is just a random number generator between 10000 and 20000.

But we can't use the default Pharo PRNG since it often hits the same value, often on the first attempt.
"
Class {
	#name : #PharoLinkPortAllocator,
	#superclass : #Object,
	#category : 'PharoLink-Server'
}

{ #category : #accessing }
PharoLinkPortAllocator class >> next [
	"Answer a randome number to use for port allocation.
	On Windows 2 images are likely to choose the same port."

	OSPlatform current name = #Win32 ifTrue:
		[ ^ (1 to: 10000) atRandom + 10000 ].

	^ '/dev/urandom' asFileReference binaryReadStreamDo:
		[ :stream | (stream next: 8) asInteger \\ 10000 + 10000 ]
]
