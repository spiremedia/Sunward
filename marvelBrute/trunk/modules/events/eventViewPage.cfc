<cfcomponent name="event View" extends="resources.page">
	<cffunction name="preobjectLoad">
		<cfset variables.eventid = variables.requestObject.getFormUrlVar('path')>
		<cfset variables.eventid = listlast(variables.eventid, "/")>

		<cfset variables.event = createObject('component','modules.events.models.events').init(requestObject)>
		<cfset variables.eventInfo = variables.event.getEvent(variables.eventid)>
		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|Events~NULL~/Events/|#variables.eventInfo.title#|">
		<cfset variables.pageInfo.title = variables.eventInfo.title>
	</cffunction>
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		<!--- main title --->
		<cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('pagetitle', 'simpleContent', data)>
	
		<!--- mainContent --->
		<cfset data = structnew()>
		<cfset data.view = 'item'>
		<cfset data.eventInfo = variables.EventInfo>
		<cfset addObjectByModulePath('middleContentItem2', 'events', data)>
	</cffunction>
</cfcomponent>