Class {
	#name : #BaselineOfPharoLink,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoLink
}

{ #category : #baseline }
BaselineOfPharoLink >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'GToolkitExternalProcess'
			with: [ spec repository: 'github://feenkcom/gtoolkit-external-process:main/src' ].

		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ];
			baseline: 'MessagePack' with: [ 
				spec repository:
						'github://feenkcom/msgpack-smalltalk:main/repository' ];
			baseline: 'Beacon'
			with: [ 
				spec repository: 'github://feenkcom/pharo-beacon/repository' ].
		spec package: 'PharoLink' with: [ spec requires: #('GToolkitExternalProcess') ] ]
]
