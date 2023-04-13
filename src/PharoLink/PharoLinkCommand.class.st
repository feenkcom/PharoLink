Class {
	#name : #PharoLinkCommand,
	#superclass : #LanguageLinkCommand,
	#category : #'PharoLink-Execution'
}

{ #category : #accessing }
PharoLinkCommand >> codeForRemote [

	^ String streamContents: [ :codeStream |
		self instructions do: [ :instr | 
			codeStream
				<< instr pharoLinkFormattedCode;
				<< '.';
				cr. ] ].
]

{ #category : #accessing }
PharoLinkCommand >> gtViewCodeForRemoteFor: aView [ 
	<gtView>
	
	^ aView textEditor
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new
				   isForWorkspace: true;
				   yourself);
		title: 'Command String' translated;
		text: [ self codeForRemote ];
		priority: 15
]
