<cfsavecontent variable="modulexml">
<moduleInfo searchable="1">
	<action match="^system/refreshSearch">
		<loadcfc>siteSearch</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>