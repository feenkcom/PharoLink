Class {
	#name : #LanguageLinkPlatform,
	#superclass : #Object,
	#instVars : [
		'msgBrokerStrategy'
	],
	#category : #'PharoLink-Platform'
}

{ #category : #accessing }
LanguageLinkPlatform class >> subProcessEnvironmentDictionary [
	"Answer the dictionary to be used when running subprocesses.
	On linux, Pharo adds the VM directory to the path, which contains non-standard versions of libssl and libcrypto.  Other applications, such as nodejs and npm, should use the default installation."

	| dict ldLibraryPath paths vmDir vmPath |

	dict := Smalltalk os environment asDictionary.
	ldLibraryPath := dict at: 'LD_LIBRARY_PATH' ifAbsent: [ ^dict ].
	paths := $: split: ldLibraryPath.
	vmDir := FileLocator vmDirectory resolve.
	vmPath := paths detect: [ :each | each asFileReference = vmDir ]
					ifNone: [ nil ].
	vmPath ifNil: [ ^dict ].
	paths remove: vmPath.
	dict at: 'LD_LIBRARY_PATH' put: (':' join: paths).
	^dict
]

{ #category : #hooks }
LanguageLinkPlatform class >> uiManagerClass [
	self subclassResponsibility
]

{ #category : #hooks }
LanguageLinkPlatform class >> weakRegistryClass [
	self subclassResponsibility
]

{ #category : #hooks }
LanguageLinkPlatform >> ensureEnvironmentForApp: anApplication [
	self subclassResponsibility
]

{ #category : #hooks }
LanguageLinkPlatform >> folderForApplication [
	self subclassResponsibility
]

{ #category : #'accessing modules' }
LanguageLinkPlatform >> messageBrokerStrategy [
	self subclassResponsibility
]

{ #category : #utils }
LanguageLinkPlatform >> newRandomName [
	self subclassResponsibility
]

{ #category : #'accessing modules' }
LanguageLinkPlatform >> serializer [
	^ self messageBrokerStrategy serializer
]

{ #category : #'module creation' }
LanguageLinkPlatform >> uiManager [
	^ self class uiManagerClass new
]

{ #category : #'module creation' }
LanguageLinkPlatform >> weakRegistry [
	^ self class weakRegistryClass new
]
