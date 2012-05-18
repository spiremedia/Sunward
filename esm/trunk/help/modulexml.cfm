<cfsavecontent variable="modulexml">
<module name="Help" label="Help" menuOrder="25" securityitems="Edit Help Item">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<!-- <template name="browseContent" title="Search" file="search.cfm"/> -->
		<template name="title" title="Welcome" file="starttitle.cfm"/>
        <template name="mainContent" title="Start Page" file="start.cfm"/>
	</action>

	<action name="Help Item" formsubmit="" template="popup-onecol">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<!-- <template name="browseContent" title="Search" file="search.cfm"/> -->
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Documentation" file="viewhelp.cfm"/>
	</action>

	<action name="Edit Help Item" formsubmit="SaveHelpItem" template="popup-onecol">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<!-- <template name="browseContent" title="Search" file="search.cfm"/> -->
		<template name="title" title="label" file="formtitlelabel.cfm"/>
		<template name="title" title="buttons" file="formtitlebutton.cfm"/>
		<template name="mainContent" title="Properties" file="edithelp.cfm"/>
	</action>

	<action name="Browse Help Items" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<!-- <action name="Search" onMenu="0" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action> -->

	<action name="Save Help Item"/>
	
	<action name="Create Pdf"/>

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>