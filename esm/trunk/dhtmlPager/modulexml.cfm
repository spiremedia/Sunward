<cfsavecontent variable="modulexml">
<module name="DHTMLPaging" label="DHTMLPaging" menuOrder="0" securityitems="">
	<action name="editClientModule" onMenu="0" template="popup-onecol" >
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="paramsform.cfm"/>
        <template name="mainContent" title="Items" file="clientmoduleform.cfm"/>
	</action>

	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



