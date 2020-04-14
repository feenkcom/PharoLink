Class {
	#name : #LanguageLinkObserver,
	#superclass : #Object,
	#instVars : [
		'id',
		'callback',
		'command'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #accessing }
LanguageLinkObserver class >> callback: aBlock [
	^ self new
		callback: aBlock;
		yourself
]

{ #category : #call }
LanguageLinkObserver >> call [
	^ self callWith: #()
]

{ #category : #call }
LanguageLinkObserver >> callWith: anArrayOrADictionary [
	^ anArrayOrADictionary jsgCallArgumentsOf: self
]

{ #category : #call }
LanguageLinkObserver >> callWith: anArray with: aDictionary [
	^ JSGCall target: self positionalArguments: anArray keywordArguments: aDictionary
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
	id := LanguageLinkUtils newVariableName
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
	^ (self callWith: (Array with: anObject))
		await: true;
		yourself
]

{ #category : #'error handling' }
LanguageLinkObserver >> notifyWith: anObject [

	^ self pharoLinkFormattedCode, ' value: ', anObject printString.
]

{ #category : #accessing }
LanguageLinkObserver >> pharoLinkFormattedCode [

	^ String streamContents: [ :stream |
		stream
			<< '[ :anObject | llCommand notify: anObject command: ';
			<< command id printString;
			<< ' observer: ';
			<< id printString;
			<< ' ]' ]
]

{ #category : #'error handling' }
LanguageLinkObserver >> pharoNotify: anObject [
	^ callback cull: anObject
]

{ #category : #testing }
LanguageLinkObserver >> writeLinkLanguageOn: aStream [
	(#observer asJSGI callWith: (Array 
											with: self command id
											with: self id)) writeLinkLanguageOn: aStream
]