<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^system/UpdateCloud/">
		<loadcfc>updateCloudFile</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>