<cfsavecontent variable="modulexml">
<module name="Content Link" label="Content Object Link" menuOrder="0" securityitems="">

	<action name="add" isform="1" template="popup-onecol" formsubmit="saveModule">
		<template name="title" title="label" file="choosetitlelabel.cfm"/>
		<template name="mainContent" title="Properties" file="chooseobjectform.cfm"/>
	</action>
    
    <action name="edit" isform="1" template="popup-onecol" formsubmit="saveModule">
		<template name="title" title="label" file="choosetitlelabel.cfm"/>
		<template name="mainContent" title="Properties" file="editobjectform.cfm"/>
	</action>

	
	<action name="Save Module"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



