<cfsavecontent variable="modulexml">
<module name="Pages" label="Pages" menuOrder="10" securityitems="Add Page,Edit Page,Delete Page,Publish Page,Reviewable Pages,Reviseable Pages,Draft Pages,Edit Page Owner,Manage Subsites">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start" file="myworkflow.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>

	<action name="Add Page" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="savePage">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="pageproperties.cfm"/>
		<template name="mainContent" title="Page Expiration" file="pageexpiration.cfm"/>
		<template name="mainContent" title="Meta Data" file="pagemetadata.cfm"/>
		<template name="mainContent" title="User Restrictions" file="userrestrictions.cfm"/>
    </action>

	<action name="Save Page"/>
	<action name="Publish Page"/>
	<action name="moveUpDown"/>
	<action name="Delete Page" isSecurityItem="1"/>

	<action name="Edit Page" isform="1" template="twocolumnwnavigation" formsubmit="savepage">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="pageproperties.cfm"/>
		<template name="mainContent" title="Page View" file="pageiframe.cfm"/>
		<template name="mainContent" title="Page Expiration" file="pageexpiration.cfm"/>
		<template name="mainContent" title="Meta Data" file="pagemetadata.cfm"/>
		<template name="mainContent" title="Link Info" file="pageinfo.cfm"/>
        <template name="mainContent" title="Page Restrictions" file="userrestrictions.cfm"/>
		<template name="mainContent" title="Page History" file="pagehistory.cfm"/>
		<template name="mainContent" title="Keyword Analysis" file="keywordanalysis.cfm"/>
	</action>

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Draft Pages View" isSecurityItem="0" template="plain">
		<template name="html" title="Draft Pages" file="draftpages.cfm"/>
	</action>

	<action name="Page Search" method="pagesearch" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

	<action name="Draft Pages" onMenu="1" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Pages" file="draftPagestitle.cfm"/>
		<template name="mainContent" title="Draft Pages" file="draftpages.cfm"/>
	</action>

	<!-- workflow -->
	<action name="Reviewable Pages" onMenu="1" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="reviewablePagesTitle.cfm"/>
		<template name="mainContent" title="Reviewables" file="reviewablepages.cfm"/>
	</action>

	<action name="Reviseable Pages" onMenu="1" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="reviseablePagesTitle.cfm"/>
		<template name="mainContent" title="Reviseables" file="reviseablepages.cfm"/>
	</action>

	<action name="Start Revise" template="onecolumnwnavigation" formsubmit="saveRevise">
		<template name="title" title="Send Feedback" file="startrevisetitle.cfm"/>
		<template name="title" title="buttons" file="startrevisebuttons.cfm"/>
		<template name="mainContent" title="Send a comment" file="reviseproperties.cfm"/>
	</action>

	<action name="Save Revise"/>

	<action name="Start Review" template="onecolumnwnavigation" formsubmit="saveReview">
		<template name="title" title="Send for Review" file="startreviewtitle.cfm"/>
		<template name="title" title="buttons" file="startreviewbuttons.cfm"/>
		<template name="mainContent" title="Choose Owner and Comment" file="reviewproperties.cfm"/>
	</action>

	<action name="Save Review"/>
    <action name="pageviewframeset" template="plain">
    	<template name="html" title="" file="pageviewwindowframeset.cfm"/>
    </action>
    <action name="pageviewframetop" template="plain">
    	<template name="html" title="" file="pageviewwindowframesettop.cfm"/>
    </action>
	<!-- /workflow -->
	<!-- revision -->
	<action name="Content Reversion" onMenu="1" template="twocolumnwnavigation" isSecurityItem="1" formsubmit="getOldReverteableObjects">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="" file="startcontentrevisiontitle.cfm"/>
		<template name="title" title="buttons" file="startcontentrevisionbuttons.cfm"/>
		<template name="mainContent" title="" file="startcontentrevisionform.cfm"/>
	</action>
	<action name="getOldReverteableObjects"/>
	<action name="showRevertableContent"/>
	<action name="getRevertibleTargetList"/>
	<action name="revertContentAction"/>
	
	<!-- Content Default -->
    <action name="Content Defaults" onMenu="1" template="twocolumnwnavigation" isSecurityItem="1" formsubmit="updateContentDefaults">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="" file="startcontentdefaulttitle.cfm"/>
		<template name="title" title="buttons" file="startcontentdefaultbuttons.cfm"/>
		<template name="mainContent" title="" file="startcontentdefaultform.cfm"/>
	</action>
	<action name="updateContentDefaults"/>
    

	<!-- keyword analysis -->
    <action name="keyword analysis"/>
    </module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



