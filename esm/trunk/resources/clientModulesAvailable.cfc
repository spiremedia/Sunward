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
			<cfset views = createObject('component', 'utilities.http').init().getPage(variables.userobject.getCurrentSiteUrl() & 'system/getModules/')>
			<cfset views = createObject('component', 'utilities.json').decode(views)>
			
			<cfcatch>
				<cfoutput>
				Trying to get views at #variables.userobject.getCurrentSiteUrl()#system/getModules/<br>
				Found #views#
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn views>
	</cffunction>
</cfcomponent>