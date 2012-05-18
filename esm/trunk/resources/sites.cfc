<cfcomponent name="sites">

	<cffunction name="init">
		<cfargument name="settings">
		
		<cfset var allsites = "">
		<cfset variables.settings = arguments.settings>
	
		<cfquery name="allsites" datasource="#variables.settings.getvar('dsn')#">
			SELECT id, name, url, info
			FROM sites
			ORDER BY name
		</cfquery>
				
		<cfset variables.siteslist = allsites>
		<cfset variables.sites = structnew()>
		
		<cfloop query="allsites">
			<cfset variables.sites[id] = structnew()>
			<cfset variables.sites[id].name = name>
			<cfset variables.sites[id].url = url>
			<cfset structappend(variables.sites[id], createObject('component','utilities.json').decode(info))>
		</cfloop>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getSiteUrl">
		<cfargument name="id">
		
		<cfif NOT structkeyexists(variables.sites, id)>
			<cfthrow message="This id is not set in sites data">
		</cfif>
		
		<cfreturn variables.sites[id]>
	</cffunction>
	
	<cffunction name="getSites">
		<cfreturn variables.siteslist>
	</cffunction>
	
	<cffunction name="getSite">
		<cfargument name="id" required="true">
		<!---><cfset var st = structnew()>
		<cfloop query="variables.siteslist">
			<cfif variables.siteslist.id EQ arguments.id>
				<cfset st.id = id>
				<cfset st.name = name>
				<cfset st.url = url>
				<cfreturn st>
			</cfif>
		</cfloop>
		<cfthrow message="sites.getsite() did not find an id  for '#id#'">--->
		<cfreturn variables.sites[id]>
	</cffunction>
    
    <cffunction name="updateSiteField">
		<cfargument name="name" required="true">
        <cfargument name="value" required="true">
        <cfargument name="siteid" required="true">
		
		<cfset var siteinfo = "">
       
        <cfquery name="siteinfo" datasource="#variables.settings.getvar('dsn')#">
			SELECT info
			FROM sites
			WHERE id = <cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
				
		<cfset siteinfo = createObject('component','utilities.json').decode(siteinfo.info)>
		
        <cfset siteinfo[name] = value>
        
        <cfset siteinfo = createObject('component','utilities.json').encode(siteinfo)>
        
        <cfquery name="siteinfo" datasource="#application.settings.getvar('dsn')#">
			UPDATE sites 
            SET info = <cfqueryparam value="#siteinfo#" cfsqltype="cf_sql_varchar">
			WHERE id = <cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
		</cfquery>
        
		<cfset init(application.settings)>
	</cffunction>
	
	<cffunction name="getSitesHTML">
		<cfargument name="user" required="true">
		
		<cfset var str = arraynew(1)>
		<cfset var sites = getSites()>
		<cfset var currentlyselected = user.getCurrentSiteID()>
		
		<cfset arrayappend(str,'<form id="site-manager" action="/login/welcome/" method="get">')>
		<cfset arrayappend(str,'<dl>')>
		<cfset arrayappend(str,'<dt><label for="s">Manage Site:</label></dt>')>
		<cfset arrayappend(str,'<dd>')>
			<cfset arrayappend(str,'<p>')>
				<cfset arrayappend(str,'<select name="switchsiteid" id="s" onchange="this.form.submit();">')>
					<cfoutput query="sites">
						<cfset arrayappend(str,'<option value="#id#" ')>
						<cfif currentlySelected EQ id>
							<cfset arrayappend(str,'selected="selected"')>
						</cfif>
						<cfset arrayappend(str,'>#name#</option>')>
					</cfoutput>	
				<cfset arrayappend(str,'</select>')>
			<cfset arrayappend(str,'</p>')>
		<cfset arrayappend(str,'</dd>')>
		<cfset arrayappend(str,'<dt><!-- leave empty --></dt>')>
		<cfset arrayappend(str,'</dl>')>
		<cfset arrayappend(str,'</form>')>

		<cfreturn arraytolist(str,"#chr(13)##chr(10)#")>
	</cffunction>
	
</cfcomponent>