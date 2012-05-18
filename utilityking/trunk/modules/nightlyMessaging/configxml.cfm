<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^System/nightlymessaging/$">
		<loadcfc>messagingloader</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>