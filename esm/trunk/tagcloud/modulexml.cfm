<cfsavecontent variable="modulexml">
<module name="tagcloud" label="Tag Cloud" menuOrder="0" securityitems="">
	<action name="editClientModule" isform="1" template="popup-onecol" formsubmit="saveContent">
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="label" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="editform.cfm"/>
	</action>
	<action name="Save Content"/>
	<action name="Delete Item"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



