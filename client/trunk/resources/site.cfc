<cfcomponent name="site">
	
	<cffunction name="init">
		<cfargument name="settings" required="true">
		<cfargument name="appEvents" required="true">
        
        <cfset var siteinfo = "">
        <cfset var itm = "">
        
        <cfquery name="siteinfo" datasource="#arguments.settings.getvar('dsn')#">
			SELECT info FROM sites WHERE id = <cfqueryparam value="#settings.getVar("siteid")#" cfsqltype="cf_sql_varchar">
        </cfquery>
        
        <cfset siteinfo = createObject('component','utilities.json').decode(siteinfo.info)>
        
        <cfloop collection="#siteinfo#" item="itm">
        	<cfset arguments.settings.setVar(itm, siteinfo[itm])>
        </cfloop>
        
		<cfset variables.settings = arguments.settings>
		<cfset variables.appEvents = arguments.appEvents>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPage">
		<cfargument name="request" required="true">
		<cfset var path = arguments.request.getformurlvar('path')>
		<cfset var page = "">
		
		<!--- first see if this page exists as simple content --->
		<cfset page = variables.searchByPath(path)>

		<!--- if not found check for application --->
		<cfif structisempty(page)>
			<cfset page = variables.appEvents.search(path)>
		</cfif>
        
        <!--- todo: maybe check here for moved pages? --->
		
		<!--- if not found load 404 --->
		<cfif structisempty(page)>
			<cfset page = variables.searchByPath('404/')>
			<cfset page.is404 = true>
			<cfif structisempty(page)>
				<cfthrow message="page not found and 404 not published.">
			</cfif>
		</cfif>
	
		<cfparam name="page.loadcfc" default="resources.page">
		
		<cfreturn  createObject('component', page.loadcfc).init(page,request)>
	</cffunction>
	
	<cffunction name="searchByPath">
		<cfargument name="path">
		<cfset var pageinfo = "">
		<cfset var pagestruct = structnew()>
		<cfset var itm = "">
		<cfif arguments.path EQ '/'>
			<cfset arguments.path = ''>
		</cfif>
		
		<cfquery name="pageinfo" result="m" datasource="#variables.settings.getvar('dsn')#">
			SELECT  id, pagename, title, description, keywords, template, breadcrumbs, parentid, urlpath,  relocate, memberTypes,  expired
			<cfif isdefined("url.preview")>
				FROM stagedPages
			<cfelse> 
				FROM publishedPages
			</cfif>
			WHERE urlpath = <cfqueryparam value="#arguments.path#" cfsqltype="cf_sql_varchar">
			<cfif isdefined("url.preview")>
				AND siteid = <cfqueryparam value="#variables.settings.getVar('siteid')#:staged">
			<cfelse>
				AND siteid = <cfqueryparam value="#variables.settings.getVar('siteid')#:published">
			</cfif>
		</cfquery>
		
		<cfif pageinfo.recordcount>
			<cfloop list="#pageinfo.columnlist#" index="itm">
				<cfset pagestruct[itm] = pageinfo[itm][1]>
			</cfloop>
		</cfif>
			
		<cfreturn pagestruct>		
	</cffunction>
	
	<cffunction name="searchByApplication">
		<cfreturn querynew('noresults')>
	</cffunction>
    
    <cffunction name="getPostProcesses">
		<cfreturn variables.appEvents.getPostProcesses()>
	</cffunction>
	
</cfcomponent>