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
				spec repository: 'github://feenkcom/gtoolkit-external-process:v0.6.146/src' ].
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:11e274dd96dc9636cab90929937b7cd09719de7c/repository' ].
		spec
			baseline: 'MessagePack' with: [
				spec repository: 'github://feenkcom/msgpack-smalltalk:v1.3.9/repository' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:56275710e68ba7921caa287bb4c61baf79dbbd08/repository' ].

		spec package: 'PharoLink' with: [
			spec requires: #(#GToolkitExternalProcess) ].
	]
]
