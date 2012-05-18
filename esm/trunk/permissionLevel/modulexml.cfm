<cfsavecontent variable="modulexml">
<module name="PermissionLevel" label="Permission Levels" topnav="true" menuOrder="3" securityitems="Add Permission Level,Edit Permission Level,Delete Permission Level">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="starttitlelabel.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>

	<action name="Add Permission Level" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="savepermissionlevel">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="Users" file="groupusers.cfm"/>
	</action>

	<action name="Save Permission Level"/>

	<action name="Edit Permission Level" isform="1" template="twocolumnwnavigation" formsubmit="savepermissionlevel">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="Users" file="groupusers.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>

	<action name="Delete Permission Level" isSecurityItem="1"/>

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



