<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^galleries/view/[a-zA-Z0-9\-]{35}/">
		<loadcfc>viewItem</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>