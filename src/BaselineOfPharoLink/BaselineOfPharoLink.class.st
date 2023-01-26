Class {
	#name : #BaselineOfPharoLink,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoLink
}

{ #category : #baseline }
BaselineOfPharoLink >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitExternalProcess' with: [
				spec repository: 'github://feenkcom/gtoolkit-external-process:v0.6.70/src' ].
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:v17/repository' ].
		spec
			baseline: 'MessagePack' with: [
				spec repository: 'github://feenkcom/msgpack-smalltalk:v1.3.5/repository' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:186df018925168422cfe065bb30abf5bae658145/repository' ].

		spec package: 'PharoLink' with: [
			spec requires: #('GToolkitExternalProcess') ].
	]
]
