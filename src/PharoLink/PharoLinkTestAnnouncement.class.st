Class {
	#name : #PharoLinkTestAnnouncement,
	#superclass : #Announcement,
	#category : #'PharoLink-Test-Runner'
}

{ #category : #accessing }
PharoLinkTestAnnouncement class >> isAbstract [

	^ self == PharoLinkTestAnnouncement
]

{ #category : #ui }
PharoLinkTestAnnouncement >> gtSummaryFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item key ];
		  column: #Value text: [ :item | item value ];
		  actionUpdateButton
]
