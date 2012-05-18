<cfcomponent name="pagesmodel" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">

		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getSiteMapObj">
		<cfargument name="view" required="true"><!--- published or staged --->
		
		<cfset var sitemap = createObject("component","resources.sitemap")>
		
		<cfif not listfind("published,staged", arguments.view)>
			<cfthrow message="getsitemapobject argument view must be either published or staged. Currently '#arguments.view#'">
		</cfif>
		
		<cfset sitemap.init('#userobj.getCurrentSiteId()#:#arguments.view#', variables.requestObj.getvar('dsn'))>
		
		<cfreturn sitemap>
	</cffunction>
	
	<cffunction name="getPages" output="false">
		<cfargument name="frmt" default="accordion">
		<cfargument name="map" required="true">
		<cfargument name="selected" default="">
		<cfargument name="persistence">
		<cfargument name="startid" default="null">
		
		<!--- get tree --->
		<cfset var formatter = "">
	
		<cfif frmt EQ 'accordion'>
			<cfset formatter = createObject('component', 'utilities.esmmenutreeformatter').init(
						arguments.selected,
						getSiteMapObj(arguments.map),
						createObject('component','widgets.accordion').init(),
						persistence,
						variables.userobj)>
			
			<cfreturn formatter.getHTML()>
		<cfelseif frmt EQ 'optionsQuery'>
			<cfset formatter = createObject('component', 'utilities.esmmenuqueryformatter').init(arguments.selected)>
		<cfelseif frmt EQ 'ultree'>
			<cfset formatter = createObject('component', 'utilities.esmmenullitreeformatter').init(arguments.selected)>
		<cfelse>
			<cfthrow message="invalid getPages formatter option '#frmt#'">
		</cfif>
		
		<cfreturn getSiteMapObj(arguments.map).getTree(variables.userobj,formatter,startid)>
	</cffunction>
	
	<cffunction name="getDraftPages" output="false">
		<!--- determine if user is allowed to root --->
		<cfset var rootallowed =  variables.userobj.isPathAllowed('')>
		<cfset var currentrow = 1>
		<cfset var totalrows = listlen(StructKeyList(variables.userobj.getAllowedPaths()))>

		<!--- get tree --->
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT sitepages.id, pagename, fname + ' ' + lname fullname, urlpath, modifieddate, modifiedby, summary
			FROM sitepages_view sitepages
			INNER JOIN users ON modifiedby = users.id
			WHERE siteid = <cfqueryparam value="#userObj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
			AND status = 'draft'
			<!--- determine if user is allowed.  --->
			<cfif NOT rootallowed >
				AND (
				<cfif totalrows eq 0>
					sitepages.id = ''
				<cfelse>
					<cfloop list="#StructKeyList(variables.userobj.getAllowedPaths())#" index="ListElement">
						urlpath LIKE <cfqueryparam value="#ListElement#%" cfsqltype="cf_sql_varchar">  
						<cfif totalrows neq currentrow>
							OR
						</cfif>
						<cfset currentrow = currentrow + 1>
					</cfloop>
				</cfif>
				)
			</cfif>
		</cfquery>
		
		<cfreturn q>
	</cffunction>
		
	<cffunction name="loadPage" output="false">
		<cfargument name="id" required="true">
		<cfset var i = "">
        
        <!--- create the page object (factory) --->
		<cfset var page = createObject('component','pages.models.page').init(variables.requestObj, userobj, this, arguments.id)>
		
		<!--- share the observers --->
		<cfif isdefined("variables.observers")>
			<cfloop from="1" to="#arraylen(variables.observers)#" index="i">
				<cfset page.attachObserver(variables.observers[i])>
			</cfloop>
		</cfif>
		
		<cfreturn page>
	</cffunction>
	
	<cffunction name="getPageChildren" output="false">
		<cfargument name="parentid" required="true">
		<cfset var smo = getSiteMapObj('published')>
		<cfreturn smo.getChildren(parentid)>
	</cffunction>
	
	<cffunction name="getNewPage" output="false">
		<cfset var i = "">
		<cfset var page = createObject('component','pages.models.page').init(variables.requestObj, userobj, this, 0)>
		<cfif isdefined("variables.observers")>
			<cfloop from="1" to="#arraylen(variables.observers)#" index="i">
				<cfset page.attachObserver(variables.observers[i])>
			</cfloop>
		</cfif>
		<cfreturn page>
	</cffunction>

	<cffunction name="getPagebyPath" output="false">
		<cfargument name="path" required="true">
		<cfargument name="pagestatus" required="false" default="staged">
		<cfset var g = "">
		<cfset arguments.path = REReplace(arguments.path, "^/", '')>
		
		<cfquery name="g" datasource="#variables.requestObj.getvar('dsn')#" result="mmme">
			SELECT id, parentid
			FROM sitepages_view
			WHERE urlpath =  <cfqueryparam value="#arguments.path#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userObj.getCurrentSiteId()#:#arguments.pagestatus#" cfsqltype="cf_sql_varchar">
		</cfquery>
				
		<cfreturn g>	
	</cffunction>
		
	<cffunction name="searchPages" output="false">
		<cfargument name="criteria" required="true">
		<cfset var g = "">
		<!--- determine if user is allowed to root --->
		<cfset var rootallowed =  variables.userobj.isPathAllowed('')>
		<cfset var currentrow = 1>
		<cfset var totalrows = listlen(StructKeyList(variables.userobj.getAllowedPaths()))>
		
		<cfquery name="g" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT id, pagename, title, urlpath, modifieddate
			FROM sitepages_view
			WHERE 
			(pagename LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> OR
			title LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">  OR
			urlpath LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> )
			AND siteid LIKE <cfqueryparam value="#variables.userObj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
			<!--- determine if user is allowed.  --->
			<cfif NOT rootallowed >
				AND (
				<cfif totalrows eq 0>
					id = ''
				<cfelse>
					<cfloop list="#StructKeyList(variables.userobj.getAllowedPaths())#" index="ListElement">
						urlpath LIKE <cfqueryparam value="#ListElement#%" cfsqltype="cf_sql_varchar">  
						<cfif totalrows neq currentrow>
							OR
						</cfif>
						<cfset currentrow = currentrow + 1>
					</cfloop>
				</cfif>
				)
			</cfif>
		</cfquery>

		<cfreturn g>
	</cffunction>
	
</cfcomponent>

<!--- TODO : add validation for checking when moving a page. should not be any similarly named pages, check order --->