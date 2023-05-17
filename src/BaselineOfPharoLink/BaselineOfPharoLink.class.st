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
				spec repository: 'github://feenkcom/gtoolkit-external-process:v0.6.80/src' ].
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:3dc868944d6eb2ba65927d3018ad13d93a7c4905/repository' ].
		spec
			baseline: 'MessagePack' with: [
				spec repository: 'github://feenkcom/msgpack-smalltalk:v1.3.5/repository' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:140c846eef357e9e94939567bad33d12abfab1bc/repository' ].

		spec package: 'PharoLink' with: [
			spec requires: #('GToolkitExternalProcess') ].
	]
]
