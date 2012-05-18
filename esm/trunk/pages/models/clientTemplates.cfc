<cfcomponent name="getTemplates">
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset structappend(variables, arguments)>
		<cfreturn this>
	</cffunction>
	<cffunction name="get">
		<cfset var views = "">
		<cftry>
			<cfset views = createObject('component', 'utilities.http').init().getPage(variables.userobject.getCurrentSiteUrl() & 'views/getViews.cfm')>
			<cfset views = createObject('component', 'utilities.json').decode(views)>
			
			<cfcatch>
				<cfoutput>
				Trying to get views at #variables.userobject.getCurrentSiteUrl()#views/getViews.cfm<br>
				Found #views#
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn views>
	</cffunction>
</cfcomponent>