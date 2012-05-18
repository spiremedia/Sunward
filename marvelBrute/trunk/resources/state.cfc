<cfcomponent name="state">
	
    <cffunction name="init">
		<cfset variables.m = structnew()>	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setvar">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">
        <cfargument name="timeValid" required="false" default="10000000">
		
		<cfset variables.m[name] = structnew()>
        <cfset variables.m[name].value = value>
        <cfset variables.m[name].expires = dateadd('n', timeValid, now())>
	</cffunction>
	
	<cffunction name="getvar">
		<cfargument name="name">
		
		<cfif not structkeyexists(variables.m, name)>
			<cfthrow message="'#name#' does not exists in state">
		</cfif>
		
		<cfreturn variables.m[name].value>
	</cffunction>
	
	<cffunction name="isvarset">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.m, name)>
	</cffunction>
    
    <cffunction name="isvarvalid">
		<cfargument name="name">
        <cfreturn structkeyexists(variables.m, name) AND now() LT variables.m[name].expires>
	</cffunction>
    
    <cffunction name="linkPathTranslator">
		<cfargument name="siteid" required="true">
        <cfargument name="pageid" required="true">
        <cfargument name="requestObject" required="true">
        
        <cfset var lcl = "">
        
		<cfif not structkeyexists(variables, 'paths')>
            <cfset loadpaths(requestObject)>
        </cfif>
        
		<cfset lcl = getLink(siteid, pageid, requestObject)>
		
        <!--- 
			if a page is not found in cached map, 
			reload map only once (see variables.loadPathsTimeStamp and requestObject.getVar('requestTimeStamp')) 
			and see if find again.
		--->
        
        <cfif left(lcl.path,4) EQ "/404">
        	<cfset loadpaths(requestObject)>
            <cfset lcl = getLink(siteid, pageid, requestObject)>
        </cfif>
        
        <cfreturn lcl.path />
	</cffunction>
    
    <cffunction name="getLink">
    	<cfargument name="siteid" required="true">
        <cfargument name="pageid" required="true">
        <cfargument name="requestObject" required="true">
        
        <cfset var l = structnew()>
        
    	<cflock name="pathtranslationloading" type="readonly" timeout="10" throwontimeout="yes">
            <cfif structkeyexists(variables.paths, arguments.siteid) AND structkeyexists(variables.paths[arguments.siteid], arguments.pageid)>
				<cfif requestObject.getVar('siteid') EQ arguments.siteid>
                	<cfset l.path = '/' &  variables.paths[arguments.siteid][arguments.pageid]/>
                <cfelseif structkeyexists(variables.sites, arguments.siteid)>
                    <!--- <cfset l.domain = replace(mid(variables.sites[arguments.siteid], 1, len(variables.sites[arguments.siteid])-1), "http://", "")> --->
                    <cfset l.path = '/' & variables.paths[arguments.siteid][arguments.pageid]>
                </cfif>
            <cfelse>
            	<cfset l.path = "/404/?path=" & arguments.siteid & "_" & arguments.pageid>
            </cfif>
        </cflock>
        
        <cfreturn l>
    </cffunction>
    
    <cffunction name="assetPathTranslator">
		<cfargument name="assetid" required="true">
        <cfargument name="requestObject" required="true">
        
        <cfset var lcl = structnew()>
        
		<cfif not structkeyexists(variables, 'assets')>
            <cfset loadpaths(requestObject)>
        </cfif>
        
        <cfset lcl = getAsset(assetid, requestObject)>
        
		<!--- 
			if an asset is not found in cached map, 
			reload map only once (see variables.loadPathsTimeStamp and requestObject.getVar('requestTimeStamp')) 
			and see if find again.
		--->
        
        <cfif left(lcl.path,4) EQ "/404">
        	<cfset loadpaths(requestObject)>
            <cfset lcl = getAsset(assetid, requestObject)>
        </cfif>

        <cfreturn lcl.path />
	</cffunction>
    
    <cffunction name="getAsset">
    	<cfargument name="assetid" required="true">
        <cfargument name="requestObject" required="true">
        
        <cfset var l = structnew()>
        
		<cflock name="pathtranslationloading" type="readonly" timeout="10" throwontimeout="yes">
            <cfif structkeyexists(variables.assets, arguments.assetid)>
				<cfset l = variables.assets[arguments.assetid]/>
            <cfelse>
            	<cfset l.path = "/404/?asset=" & arguments.assetid>
            </cfif>
        </cflock>
        
        <cfreturn l>
    </cffunction>
	
   <!---  <cffunction name="pathTranslator">
		<cfargument name="siteid" required="true">
        <cfargument name="pageid" required="true">
        
		<cfif not structkeyexists(variables, 'paths')>
            <cfset loadpaths()>
        </cfif>
        
		<cflock name="pathtranslationloading" type="readonly" timeout="10" throwontimeout="yes">
            <cfif structkeyexists(variables.paths, arguments.siteid) AND structkeyexists(variables.paths[arguments.siteid], arguments.pageid)>
                <cfreturn variables.paths[arguments.siteid][arguments.pageid]/>
            </cfif>
        </cflock>
		
        <cfreturn "404/?path=" & arguments.siteid & "_" & arguments.pageid>
	</cffunction> --->
    
    <cffunction name="loadPaths">
		<cfargument name="requestObject" required="true">
   		<cfset var allpages = "">

        <cfset var paths = structnew()>
		<cfset var result = "">
        <cfset var sitesq = "">
        <cfset var sites = structnew()>
        <cfset var assetsq = "">
        <cfset var assets = structnew()>
        
        <!--- only load paths once per request --->
        <cfif isdefined("variables.loadPathsTimeStamp") AND variables.loadPathsTimeStamp EQ requestObject.getVar('requestTimeStamp')>
        	<cfreturn>
        </cfif>
        
        <cfset variables.loadPathsTimeStamp = requestObject.getVar('requestTimeStamp')>
        
        <cflock name="pathtranslationloading" type="exclusive" timeout="10">
            <cfquery name="allpages" datasource="#requestObject.getVar('dsn')#" result="result">
                SELECT id, SUBSTRING(siteid, 0, 36) siteid, urlpath , siteid
                FROM sitepages_view
                WHERE
                    expired = 0
            </cfquery>
            
            <cfquery name="sitesq" datasource="#requestObject.getVar('dsn')#" result="result">
                SELECT id, url
                FROM sites
            </cfquery>
            
            <cfquery name="assetsq" datasource="#requestObject.getVar('dsn')#" result="result">
                SELECT id, name, '/docs/assets/' + id + '/' + filename link
                FROM assets
            </cfquery>
           
            <cfloop query="allpages">
            	<cfif NOT structkeyexists(paths, allpages.siteid)>
                	<cfset paths[allpages.siteid] = structnew()>
                </cfif>
            	<cfset paths[allpages.siteid][allpages.id] = allpages.urlpath>
            </cfloop>
            
            <cfloop query="sitesq">
            	<cfset sites[sitesq.id] = sitesq.url>
            </cfloop>
            
            <cfloop query="assetsq">
            	<cfset assets[assetsq.id] = structnew()>
				<cfset assets[assetsq.id].path = assetsq.link>
                <cfset assets[assetsq.id].name = assetsq.name>
            </cfloop>
       
			<cfset variables.paths = paths>
            <cfset variables.sites = sites>
            <cfset variables.assets = assets>
        </cflock>
    </cffunction>
    	
	<cffunction name="dump">
		<cfdump var=#variables#><cfabort>
	</cffunction>
    
</cfcomponent>