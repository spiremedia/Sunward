<cfcomponent name="stateMgr" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfset var so = "">
		<cfset var sm = "">
		<cfset var mode = "">
		<cfset var params = variables.requestObject.getAllFormUrlVars()>
	
		<cfif NOT structkeyexists(params, 'module')>
			<cfthrow message="state mgr called with no module parameter">
		</cfif>
	
		<cfset so = createObject('component','modules.#params.module#.controller').init(requestObject)>
		<cfset sm = createObject('component','resources.sitemap').init(requestObject, this)>
		<cfset so.updateState(params, sm)>
		
		<cfabort>
	</cffunction>
</cfcomponent>