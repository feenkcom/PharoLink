Class {
	#name : #LanguageLinkPromiseRegistry,
	#superclass : #Object,
	#instVars : [
		'promiseTable',
		'semaphore'
	],
	#category : #'PharoLink-Execution'
}

{ #category : #adding }
LanguageLinkPromiseRegistry >> addPromise: aPromise [
	semaphore critical: [ promiseTable at: aPromise id put: aPromise ]
]

{ #category : #initialization }
LanguageLinkPromiseRegistry >> initialize [
	super initialize.
	promiseTable := Dictionary new.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #instructions }
LanguageLinkPromiseRegistry >> notifyDebuggerPaused: aDebugger [
	"Notify all promises that the server debugger has paused in case the Bloc UI process is waiting on one of the promises."
	| signal promises |

	signal := PharoLinkDebuggerPaused new debuggerClient: aDebugger.
	semaphore critical: [ promises := promiseTable values ].
	promises do: [ :promise |
		promise signalWithValue: signal copy ].
]

{ #category : #'private - testing' }
LanguageLinkPromiseRegistry >> promiseTable [
	^ promiseTable
]

{ #category : #adding }
LanguageLinkPromiseRegistry >> removeAndSignalPromiseId: id with: anObject [
	self signalPromiseId: id with: anObject.
	self removePromiseId: id
]

{ #category : #adding }
LanguageLinkPromiseRegistry >> removePromiseId: id [
	semaphore critical: [ promiseTable removeKey: id ]
]

{ #category : #adding }
LanguageLinkPromiseRegistry >> signalPromiseId: id with: anObject [
	| promise |
	semaphore critical: [ 
		promise := promiseTable at: id ].
	promise signalWithValue: anObject.
]
