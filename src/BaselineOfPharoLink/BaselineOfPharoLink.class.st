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
				with: [ spec repository: 'github://feenkcom/OSSubprocess/repository' ].
			spec baseline: 'NeoJSON' with: [
                spec
                    repository: 'github://svenvc/NeoJSON/repository' ].
            spec baseline: 'GToolkitRemote' with: [
                spec
                    repository: 'github://feenkcom/gtoolkit-remote/src' ].
			spec baseline: 'MessagePack' with: [
                spec
                    repository: 'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ].
			spec
				package: 'PharoLink' "with: [ spec requires: #('OSSubprocess') ]"
			 ]
]
