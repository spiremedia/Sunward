<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="formcontent">
		<loadcfc>formContent</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>