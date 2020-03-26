Class {
	#name : #PharoLinkRemoteErrorExamples,
	#superclass : #Object,
	#category : #'PharoLink-Examples'
}

{ #category : #tests }
PharoLinkRemoteErrorExamples >> formattedText [ 
	<gtExample>
	| errorString remoteError formattedText filename |

	remoteError := PharoLinkRemoteError new.

	errorString := 
'TypeError: value.match is not a function
    at Worksheet.doIt (eval at execute (/path/to/source/file.js:44:4), <anonymous>:16:19)'.
	formattedText := remoteError formattedText: errorString.
	"Just before and after the filename there are no attributes"
	self assert: (formattedText attributesAt: 81) isEmpty.
	self assert: (formattedText attributesAt: 105) isEmpty.
	"In the filename there are two: color and click"
	self assert: (formattedText attributesAt: 82) size equals: 2.
	self assert: (formattedText attributesAt: 104) size equals: 2.
	^ formattedText.
]
