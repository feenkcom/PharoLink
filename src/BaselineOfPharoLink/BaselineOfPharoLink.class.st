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
				spec repository: 'github://feenkcom/pharo-beacon:a119e739bc378ca2a95883e074090d90fed4edeb/repository' ].

		spec package: 'PharoLink'.
	]
]
