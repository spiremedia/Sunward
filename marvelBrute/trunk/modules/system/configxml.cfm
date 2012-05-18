<cfsavecontent variable="modulexml">
<moduleInfo embedeable="false">
	<action match="^system/stateMgr/?">
		<loadcfc>mgr</loadcfc>
	</action>
	<action match="^system/getViews/?">
		<loadcfc>views</loadcfc>
	</action>
	<action match="^system/getModules/?">
		<loadcfc>modules</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>

