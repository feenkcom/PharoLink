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
				spec repository: 'github://feenkcom/gtoolkit-external-process:v0.6.120/src' ].
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:f54cfb4a931971ed356d1dfde0e135951e82daae/repository' ].
		spec
			baseline: 'MessagePack' with: [
				spec repository: 'github://feenkcom/msgpack-smalltalk:v1.3.7/repository' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:3781b1cde08bf28c5e0c6783ec854801e28cdc5e/repository' ].

		spec package: 'PharoLink' with: [
			spec requires: #(#GToolkitExternalProcess) ].
	]
]
