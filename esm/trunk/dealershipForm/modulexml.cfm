<cfsavecontent variable="modulexml">
<module name="dealershipForm" label="dealershipForm" menuOrder="0" securityitems="">
	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>
	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>







