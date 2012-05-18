<cfcomponent name="viewspage" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfoutput>
			#application.views.getViewData(true)#
		</cfoutput>
		<cfabort>
	</cffunction>
</cfcomponent>