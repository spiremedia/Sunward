<cfcomponent name="logobserver">
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>

	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="publish page,page up down,delete page,move page">
				<cfset processPage(modelref)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="processPage">
		<cfargument name="pageref" required="true">
		
		<cfset var smo = pageref.getPagesObj().getSiteMapObj('published')>
		<cfset var parents = smo.getParents(pageref.getPageid())>
		<cfset var state = application.modules.getState()>
		<cfset var siteid = session.user.getCurrentSiteId()>
		
		<cfif parents.recordcount EQ 1>
			<cfset state.removevar("_#siteid#_#pageref.getPageId()#")>
		<cfelseif parents.recordcount GT 1>
			<cfset state.removevar("_#siteid#_#parents.id[parents.recordcount - 1]#")>
		</cfif>
	</cffunction>
</cfcomponent>