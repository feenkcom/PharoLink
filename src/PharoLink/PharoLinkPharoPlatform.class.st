Class {
	#name : #PharoLinkPharoPlatform,
	#superclass : #PharoLinkPlatform,
	#category : 'PharoLink-Pharo-Platform'
}

{ #category : #private }
PharoLinkPharoPlatform class >> uiManagerClass [
	^ LanguageLinkPharoUiManager
]

{ #category : #hooks }
PharoLinkPharoPlatform class >> weakRegistryClass [
	^ LanguageLinkPharoWeakRegistry
]

{ #category : #'private - symlinks' }
PharoLinkPharoPlatform >> createSymlinkFor: originalFile on: targetFile [
	OSSUnixSubprocess new
				command: '/bin/ln';
				arguments: (Array 
									with: '-s' 
									with: originalFile asFileReference fullName 
									with: targetFile asFileReference fullName);
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command | ^ self ].
]

{ #category : #utils }
PharoLinkPharoPlatform >> ensureEnvironmentForApp: anApplication [
	" Currently assumes the current environment, so nothing to do"
]

{ #category : #utils }
PharoLinkPharoPlatform >> folderForApplication [

	^ FileLocator imageDirectory
]

{ #category : #hooks }
PharoLinkPharoPlatform >> newRandomName [
	^ 'pb' , UUID new asString36
]

{ #category : #private }
PharoLinkPharoPlatform >> signalInstallEnvFailed [
	"The attempt to install all the required packages with npm failed for some reason"

	Error signal: 'npm install failed.'
]
