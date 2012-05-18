<cfcomponent name="siteSearch" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfset var so = "">
		<cfset var plist = structnew()>
		<!--- security --->
		<cfif NOT isIPSafe(ip = CGI.REMOTE_ADDR)>
			Access Denied. You do not have sufficient privileges to view this page.<cfabort>
		</cfif>
		
		<cfsetting requesttimeout="50000">
		<cfset plist.indexcontrol = 1>
		<cfset so = createObject('component','modules.search.controller').init(requestObject = requestObject, parameterlist = plist)>
		
		<cfabort>
	</cffunction>
</cfcomponent>