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
			baseline: 'OSSubprocess' with: [
				spec repository: 'github://feenkcom/OSSubprocess:main/repository' ];
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:v17/repository' ];
			baseline: 'MessagePack' with: [
				spec repository: 'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ];
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon/repository' ].
		spec package: 'PharoLink'. ].

]
