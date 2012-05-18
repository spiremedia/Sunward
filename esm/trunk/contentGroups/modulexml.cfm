<cfsavecontent variable="modulexml">
<module name="ContentGroups" label="Content Groups" topnav="true" menuOrder="4" securityitems="Add Content Group,Edit Content Group,Delete Content Group">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Start Page" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>

	<action name="Add Content Group" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="savecontentgroup">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="Users" file="groupusers.cfm"/>
		<template name="mainContent" title="Asset Groups" file="groupassetgroups.cfm"/>
	</action>

	<action name="Save Content Group"/>

	<action name="Edit Content Group" isform="1" template="twocolumnwnavigation" formsubmit="savecontentgroup">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="Users" file="groupusers.cfm"/>
		<template name="mainContent" title="Asset Groups" file="groupassetgroups.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>

	<action name="Delete Content Group" isSecurityItem="1"/>

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Group Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



