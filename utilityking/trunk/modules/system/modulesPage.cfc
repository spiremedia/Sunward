<cfcomponent name="modulespage" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfoutput>
			
			#createObject('component', 'utilities.json').encode(application.modules.getEmbedeableModules())#
		</cfoutput>
		<cfabort>
	</cffunction>
</cfcomponent>