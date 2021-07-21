Class {
	#name : 'LanguageLinkUtils',
	#superclass : 'Object',
	#category : 'PharoLink-Core'
}

{ #category : 'instance creation' }
LanguageLinkUtils class >> newVariableName [
	^ 'll' , UUID new asString36
]
