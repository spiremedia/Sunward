<cfsavecontent variable="modulexml">
<module name="Galleries" label="Galleries" menuOrder="19" securityitems="Add Gallery Image,Edit Gallery Image,Delete Gallery Image,View Gallery Groups,Add Gallery Group,Save Client Module,Save Gallery Group,Edit Gallery Group,Delete Gallery Group">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Welcome to the Images Area" file="start.cfm"/>
        <template name="mainContent" title="Start Page" file="start.cfm"/>
        <template name="mainContent" title="Recent Site Activity" file="recentHistory.cfm"/>
	</action>

	<action name="Add Gallery Image" onMenu="1" isSecurityItem="1" isform="1" template="twocolumnwnavigation" formsubmit="saveGalleryImage">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

	<action name="Save Gallery Image"/>

	<action name="Edit Gallery Image" isform="1" template="twocolumnwnavigation" formsubmit="saveGalleryImage">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
        <template name="mainContent" title="Edit Image" file="editImage.cfm"/>
		<template name="mainContent" title="View Images" file="viewImages.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>
    
    <action name="eaImg"/>
    <action name="view Image" />
	
	<action name="Delete Gallery Image" isSecurityItem="1"/>
	
	<action name="Upload Gallery Image" template="onecolumnwnavigation">
		<template name="title" title="buttons" file="uploadtitle.cfm"/>
		<template name="title" title="buttons" file="uploadbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="uploadform.cfm"/>
	</action>
	
	<action name="Upload Gallery Image Action" />
	
	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Search" onMenu="0" isSecurityItem="0" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>
	
	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>
	
	<action name="View Gallery Groups" onMenu="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browseGroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="Start Page" file="startgrouptitle.cfm"/>
		<template name="mainContent" title="Start Page" file="startgroups.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentGroupActivity.cfm"/>
	</action>
	
	<action name="Add Gallery Group" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveGallerygroup">
		<template name="browseContent" title="Browse" file="browseGroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="label" file="titlegrouplabel.cfm"/>
		<template name="title" title="buttons" file="titlegroupbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
	</action>
	
	<action name="Save Gallery Group"/>
	
	<action name="Edit Gallery Group" isform="1" template="twocolumnwnavigation" formsubmit="saveGallerygroup">
		<template name="browseContent" title="Browse" file="browseGroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="label" file="titlegrouplabel.cfm"/>
		<template name="title" title="buttons" file="titlegroupbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="History" file="grouphistory.cfm"/>
	</action>
	
	<action name="Delete Gallery Group" isSecurityItem="1"/>

	<action name="BrowseGroups" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browseGroups.cfm"/>
		<template name="html" title="Search" file="searchGroups.cfm"/>
	</action>

	<action name="Image Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>
	
	<images>
		<img name="Main" maxwidth="600" maxheight="500" extensionmod="_img"/>
		<img name="Medium" maxwidth="400" maxheight="300" extensionmod="_med"/>
		<img name="Thumb" maxwidth="150" maxheight="140" extensionmod="_thmb"/>
	</images>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



