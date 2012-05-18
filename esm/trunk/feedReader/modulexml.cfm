<cfsavecontent variable="modulexml">
<module name="News" label="News" menuOrder="0" securityitems="Add News,Edit News,Delete News">
	<action name="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>
	
	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>
    <action name="TestFeed"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



