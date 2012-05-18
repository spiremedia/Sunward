<cfsavecontent variable="modulexml">
<module name="Users" label="Users" menuOrder="2" topnav="true" securityitems="Add User,Edit User,See Passwords,See Others,Edit Others,Delete User">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>
	
	<action name="Add User" onMenu="1" isSecurityItem="1" formsubmit="SaveUser" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
	
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="userproperties.cfm"/>
		<template name="mainContent" title="Address" file="useraddress.cfm"/>
	</action>
	
	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>
	
	<action name="Search"  onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

	<action name="Save User" method="SaveUser" onSuccess="startPage/"/>

	<action name="Edit User" isSecurityItem="1" formsubmit="SaveUser" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
	
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="userproperties.cfm"/>
		<template name="mainContent" title="Address" file="useraddress.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>

	<action name="Delete User" method="DeleteUser" isSecurityItem="1" onSuccess="startPage"/>

</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>

<!---
	<cfset moduleinfo.name = modulexml.module.xmlattributes.name>
		<cfset moduleinfo.label = modulexml.module.xmlattributes.label>
		<cfset moduleinfo.menuorder = modulexml.module.xmlattributes.menuorder>
		<cfset moduleinfo.securityItems = modulexml.module.xmlattributes.securityitems>

		<cfset actions = xmlsearch(modulexml, '//module/action/')>
		<cfset moduleinfo.actionsarray = arraynew(1)>


		<cfloop from="1" to="#arraylen(actions)#" index="i">
			<cfset thisaction = actions[i]>
			<cfset thisactioninfo = structnew()>

			<!---<cfset thisactioninfo.template = thisaction.xmlattributes.template>--->

			<cfif structkeyexists(thisaction.xmlattributes, "method")>
				<cfset thisactioninfo.method = thisaction.xmlattributes.method>
			<cfelse>
				<cfset thisactioninfo.method = rereplace(thisaction.xmlattributes.name,"[^a-zA-Z0-9]","","all")>
			</cfif>

			<cfif structkeyexists(thisaction.xmlattributes, "onsuccess")>
				<cfset thisactioninfo.onsuccess = thisaction.xmlattributes.onsuccess>
			</cfif>

			<cfif structkeyexists(thisaction.xmlattributes, 'isform') AND thisaction.xmlattributes.isform>
				<cfset thisactioninfo.isform = 1>
			<cfelse>
				<cfset thisactioninfo.isform = 0>
			</cfif>

			<cfif structkeyexists(thisaction.xmlattributes, 'issecurityitem') AND thisaction.xmlattributes.issecurityitem>
				<cfset thisactioninfo.issecurityitem = 1>
			<cfelse>
				<cfset thisactioninfo.issecurityitem = 0>
			</cfif>

			<cfif structkeyexists(thisaction.xmlattributes, 'onmenu') AND thisaction.xmlattributes.issecurityitem>
				<cfset thisactioninfo.onmenu = 1>
			<cfelse>
				<cfset thisactioninfo.onmenu = 0>
			</cfif>

			<cfset templates = arraynew(1)>

			<cfif arraylen(thisaction.xmlchildren)>
				<cfloop from="1" to="#arraylen(thisaction.xmlchildren)#" index="j">
					<cfset template = thisaction.xmlchildren[j]>

					<cfset templateinfo.file = template.xmlattributes.file>
					<cfset templateinfo.name = template.xmlattributes.name>
					<cfset templateinfo.title = template.xmlattributes.title>
					<cfset arrayappend(templates, template)>
				</cfloop>
				<cfset thisactioninfo.templates = templates>
			</cfif>
			<cfset arrayappend(moduleinfo.actionsarray, thisactioninfo)>
			<cfset moduleinfo.actions[thisactioninfo.method] = thisactioninfo>
		</cfloop>


<cfdump var=#moduleinfo#>

`--->