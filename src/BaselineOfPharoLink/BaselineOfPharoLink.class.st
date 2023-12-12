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
				spec repository: 'github://feenkcom/gtoolkit-external-process:v0.6.101/src' ].
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:1d81fa2c0b3806ea31d9a8b4a8d8a12d8ffa6a77/repository' ].
		spec
			baseline: 'MessagePack' with: [
				spec repository: 'github://feenkcom/msgpack-smalltalk:v1.3.6/repository' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:93329815ac3935bcbf46b3e38b83324b5a32ac37/repository' ].

		spec package: 'PharoLink' with: [
			spec requires: #('GToolkitExternalProcess') ].
	]
]
