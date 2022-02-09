Class {
	#name : #LanguageLinkObserver,
	#superclass : #Object,
	#instVars : [
		'id',
		'callback',
		'command',
		'answerEncoding'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #accessing }
LanguageLinkObserver class >> callback: aBlock [
	^ self new
		callback: aBlock;
		yourself
]

{ #category : #accessing }
LanguageLinkObserver >> callback [
	^ callback
]

{ #category : #accessing }
LanguageLinkObserver >> callback: anObject [
	callback := anObject
]

{ #category : #accessing }
LanguageLinkObserver >> command [
	^ command
]

{ #category : #accessing }
LanguageLinkObserver >> command: anObject [
	command := anObject
]

{ #category : #accessing }
LanguageLinkObserver >> id [
	^ id
]

{ #category : #initialization }
LanguageLinkObserver >> initialize [
	super initialize.
	id := LanguageLinkUtils newVariableName.
	answerEncoding := #never.
]

{ #category : #testing }
LanguageLinkObserver >> isJavaScriptGenerable [
	^ true
]

{ #category : #testing }
LanguageLinkObserver >> isLanguageLinkValue [
	^ true
]

{ #category : #'error handling' }
LanguageLinkObserver >> javaScriptNotify [
	^ self javaScriptNotify: nil
]

{ #category : #'error handling' }
LanguageLinkObserver >> javaScriptNotify: anObject [
	^ (self jsCallWith: (Array with: anObject))
		await: true;
		yourself
]

{ #category : #call }
LanguageLinkObserver >> jsCall [
	^ self jsCallWith: #()
]

{ #category : #call }
LanguageLinkObserver >> jsCallWith: anArrayOrADictionary [
	^ anArrayOrADictionary jsgCallArgumentsOf: self
]

{ #category : #'error handling' }
LanguageLinkObserver >> notifyWith: anObject [

	^ self pharoLinkFormattedCode, ' value: ', anObject printString.
]

{ #category : #accessing }
LanguageLinkObserver >> pharoLinkFormattedCode [

	^ String streamContents: [ :stream |
		stream
			<< '[ :anObject | '.
		answerEncoding = #never ifFalse:
			[ stream 
				<< 'PharoLinkAnswerByValue value: ';
				print: answerEncoding;
				<< ' during: [ ' ].
		stream
			<< 'llCommand notify: anObject command: ';
			<< command id printString;
			<< ' observer: ';
			<< id printString;
			<< ' ]'.
		answerEncoding = #never ifFalse:
			[ stream << ' ]' ]
		 ]
]

{ #category : #'error handling' }
LanguageLinkObserver >> pharoNotify: anObject [
	^ callback cull: anObject
]

{ #category : #encoding }
LanguageLinkObserver >> setByProxy [

	answerEncoding := #never
]

{ #category : #encoding }
LanguageLinkObserver >> setBySerialized [

	answerEncoding := #serialized
]

{ #category : #encoding }
LanguageLinkObserver >> setByValue [

	answerEncoding := #value
]

{ #category : #encoding }
LanguageLinkObserver >> setByValueOnly [

	answerEncoding := #valueOnly
]

{ #category : #testing }
LanguageLinkObserver >> writeJavaScriptOn: aStream [
	(#observer asJSGI jsCallWith: (Array 
											with: self command id
											with: self id)) writeJavaScriptOn: aStream
]
