<cfsavecontent variable="modulexml">
<module name="SiteMembers" label="Site Members" menuOrder="22" securityitems="Add Member,Edit Member,Delete Member,View Member Types,Add Member Type,Edit Member Type,Delete Member Type">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Welcome to the Members Area" file="start.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>

	<action name="Add Member" onMenu="1" isSecurityItem="1" isform="1" template="twocolumnwnavigation" formsubmit="savemember">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

	<action name="Save Member"/>

	<action name="Edit Member" isform="1" template="twocolumnwnavigation" formsubmit="savemember">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>
        
	<action name="Delete Member" isSecurityItem="1"/>

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
	
	<action name="View Member Types" onMenu="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browseTypes.cfm"/>
		<template name="browseContent" title="Search" file="searchTypes.cfm"/>
		<template name="title" title="Start Page" file="startTypes.cfm"/>
		<template name="mainContent" title="Start Page" file="startTypes.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivityTypes.cfm"/>
	</action>

	<action name="Add Member Type" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="savemembertype">
		<template name="browseContent" title="Browse" file="browseTypes.cfm"/>
		<template name="browseContent" title="Search" file="searchTypes.cfm"/>
		<template name="title" title="label" file="titlelabelTypes.cfm"/>
		<template name="title" title="buttons" file="titlebuttonsTypes.cfm"/>
		<template name="mainContent" title="Properties" file="propertiesTypes.cfm"/>
	</action>
	
	<action name="Save Member Type"/>
	
    <action name="Edit Member Type" isform="1" template="twocolumnwnavigation" formsubmit="savemembertype">
		<template name="browseContent" title="Browse" file="browseTypes.cfm"/>
		<template name="browseContent" title="Search" file="searchTypes.cfm"/>
		<template name="title" title="label" file="titlelabelTypes.cfm"/>
		<template name="title" title="buttons" file="titlebuttonsTypes.cfm"/>
		<template name="mainContent" title="Properties" file="propertiesTypes.cfm"/>
		<template name="mainContent" title="History" file="historyTypes.cfm"/>
	</action>
	
	<action name="Delete Member Type" isSecurityItem="1"/>

	<action name="Browse Member Types" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browseTypes.cfm"/>
		<template name="html" title="Search" file="searchTypes.cfm"/>
	</action>

	<action name="Search Member Types" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browseTypes.cfm"/>
		<template name="browseContent" title="Search" file="searchTypes.cfm"/>
		<template name="title" title="Search Results" file="searchtitleTypes.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresultsTypes.cfm"/>
	</action>
    
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



