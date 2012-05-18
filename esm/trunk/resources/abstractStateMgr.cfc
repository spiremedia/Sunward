<cfcomponent displayname="abstractStateMgr" output="false">

	<cffunction name="sendNotification">
		<cfset siteinfo = application.sites.getSite(variables.userObject.getCurrentSiteId())>
		
		<cfif structkeyexists(siteinfo, 'urlinstances')>
			<cfset urlinstances = siteinfo.urlinstances>
		<cfelse>
			<cfset urlinstances = session.user.getCurrentSiteUrl()>
		</cfif>

		<!--- loop over site domains --->
		<cfloop list="#urlinstances#" index="site">
			<cfset notifyInstance(site & 'system/stateMgr/')>
		</cfloop>
	
	</cffunction>
	
	<cffunction name="notifyInstance">
		<cfargument name="url" required="true">
		
		<cfset var itm = "">
		<cfset var m = "">

		<cfhttp url="#arguments.url#" method="get" result="m">
			<cfloop collection="#variables.stateMgrParams#" item = "itm">
				<cfhttpparam type="url" name="#itm#" value="#variables.stateMgrParams[itm]#">
			</cfloop>
		</cfhttp>

		<cfif m.fileContent NEQ 'ok'>
        	<cfset createObject('component','utilities.varlogger').init(
				name="statMgrErrors",
				requestObject = requestObject,
				data = m.fileContent
			)>
			<!--- TODO do something if one of the sites fails --->
		</cfif>
	</cffunction>
	
	<cffunction name="addStateParam">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">
		
		<cfif not isdefined("variables.stateMgrParams")>
			<cfset variables.stateMgrParams = structnew()>
		</cfif>
		
		<cfset variables.stateMgrParams[name] = value>
	</cffunction>
</cfcomponent>