Extension { #name : #OSWSWinProcess }

{ #category : #'*PharoLink' }
OSWSWinProcess >> isRunning [

	"see https://docs.microsoft.com/en-us/windows/desktop/api/synchapi/nf-synchapi-waitforsingleobject for more information"

	| returnValue |
	(processInfo isNil or: [ 
		 processInfo getHandle isNil or: [ 
			 processInfo getHandle isNull or: [ 
				 processInfo hProcess getHandle isNull ] ] ]) ifTrue: [ ^ false ].

	returnValue := self ffiLibrary
		               waitForSingleObject: processInfo hProcess
		               milliSeconds: 0.
	^ returnValue = self class WAIT_TIMEOUT
]
