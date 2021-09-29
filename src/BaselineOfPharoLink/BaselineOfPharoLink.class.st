Class {
	#name : 'BaselineOfPharoLink',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoLink'
}

{ #category : 'baseline' }
BaselineOfPharoLink >> baseline: spec [

	<baseline>
	| subprocess |
	spec for: #common do: [ 
		Smalltalk platform isWindows
			ifTrue: [ 
				spec
					baseline: 'OSWinSubprocess'
					with: [ 
					spec repository: 'github://pharo-contributions/OSWinSubprocess' ].
				subprocess := 'OSWinSubprocess' ]
			ifFalse: [ 
				spec
					baseline: 'OSSubprocess'
					with: [ 
					spec repository: 'github://feenkcom/OSSubprocess:main/repository' ].
				subprocess := 'OSSubprocess' ].
		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON:v17/repository' ];
			baseline: 'MessagePack' with: [ 
				spec repository:
						'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ];
			baseline: 'Beacon'
			with: [ 
				spec repository: 'github://feenkcom/pharo-beacon/repository' ].
		spec package: 'PharoLink' ]
]
