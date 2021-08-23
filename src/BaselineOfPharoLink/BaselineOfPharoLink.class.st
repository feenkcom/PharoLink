Class {
	#name : 'BaselineOfPharoLink',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoLink'
}

{ #category : 'baseline' }
BaselineOfPharoLink >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'OSSubprocess' with: [
				spec repository: 'github://feenkcom/OSSubprocess:v1.1.20/repository' ].
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:v17/repository' ].
		spec
			baseline: 'MessagePack' with: [
				spec repository: 'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ].
		spec
			baseline: 'Beacon' with: [
				spec repository: 'github://feenkcom/pharo-beacon:e0669184913a76cfffca4eaecb7de025a3e65861/repository' ].

		spec package: 'PharoLink'.
	]
]
