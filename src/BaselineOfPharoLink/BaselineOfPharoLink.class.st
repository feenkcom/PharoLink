Class {
	#name : #BaselineOfPharoLink,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoLink
}

{ #category : #baselines }
BaselineOfPharoLink >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [			
			spec
				baseline: 'OSSubprocess' 
				with: [ spec repository: 'github://feenkcom/OSSubprocess:main/repository' ].
			spec 
				baseline: 'NeoJSON' 
				with: [ spec repository: 'github://svenvc/NeoJSON:v17/repository' ].
			spec 
				baseline: 'MessagePack' 
				with: [ spec repository: 'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ].
			spec 
				baseline: 'Beacon' 
				with: [ spec repository: 'github://feenkcom/pharo-beacon/repository' ].
			spec
				package: 'PharoLink' "with: [ spec requires: #('OSSubprocess') ]"
			 ]
]
