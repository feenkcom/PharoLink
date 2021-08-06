Class {
	#name : 'PharoLinkCommand',
	#superclass : 'LanguageLinkCommand',
	#category : 'PharoLink-Execution'
}

{ #category : 'accessing' }
PharoLinkCommand >> codeForRemote [

	^ String streamContents: [ :codeStream |
		self instructions do: [ :instr | 
			codeStream
				<< instr pharoLinkFormattedCode;
				<< '.';
				cr. ] ].
]
