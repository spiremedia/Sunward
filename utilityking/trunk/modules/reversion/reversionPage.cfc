<cfcomponent name="news View" extends="resources.page">
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>

		<!--- load reversion item --->
		<cfquery name="lcl.reversioninfo" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT [module], data
			FROM publishedPageObjectsArchive
			WHERE id = <cfqueryparam value="#variables.requestObject.getFormUrlVar('id')#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif lcl.reversioninfo.recordcount EQ 0>
			<cfthrow message="no data">
		</cfif>
			
		<cfif left(lcl.reversioninfo.data, 1) EQ '{'>	
			<cfset data = createObject('component','utilities.json').decode(lcl.reversioninfo.data)>
		<cfelse>
			<cfset data = lcl.reversioninfo.data>
		</cfif>
		
		<!--- check if reversion is available for module.  ugly if construct. sorry. --->
		<cfif fileexists(requestObject.getVar('machineroot') & "/modules/#lcl.reversioninfo.module#/configxml.cfm")>
			<cfinclude template="../#lcl.reversioninfo.module#/configxml.cfm">
			<cfif NOT (structkeyexists(modulexml.moduleInfo.xmlattributes,'hasReversionView') AND modulexml.moduleInfo.xmlattributes.hasReversionView)>
				Reversion preview is not available for this module. The item is still reversionable so you may continue.<cfabort>
			</cfif>
		<cfelse>
			Reversion preview is not available for this module. The item is still reversionable so you may continue.<cfabort>
		</cfif>
		
		<!--- load module --->
		<cfset addObjectByModulePath('onecontent', lcl.reversioninfo.module, data)>
		
	</cffunction>
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>