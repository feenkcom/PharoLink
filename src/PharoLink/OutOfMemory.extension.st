Extension { #name : #OutOfMemory }

{ #category : #'*PharoLink' }
OutOfMemory >> description [

	^ String streamContents: [ :stream |
		stream 
			<< self class name;
			<< ': size requested: ';
			<< self isqByteSizeRequested ]
]

{ #category : #'*PharoLink' }
OutOfMemory >> isqByteSizeRequested [
	<return: #String>

	^ self signalerContext
		ifNil: [ 'context is nil' ]
		ifNotNil: [ :context | [ context stack
			detect: [ :aContext | aContext selector = #handleFailingBasicNew: ]
			ifFound: [ :aContext | 
				(aContext receiver
					byteSizeOfInstanceOfSize: (aContext tempNamed: #sizeRequested))
					humanReadableIsqByteSize ]
			ifNone: [ 'context not found' ] ]
				on: MessageNotUnderstood
				do: [ :ex | 'unable to calculate' ] ]
]

{ #category : #'*PharoLink' }
OutOfMemory >> pharoLinkAdditionalData [
	
	^ {#sizeRequested -> self isqByteSizeRequested} asDictionary.
]
