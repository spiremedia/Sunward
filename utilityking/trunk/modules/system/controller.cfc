<cfcomponent extends="resources.abstractController" ouput="true">
	<!---  
		cache files are created by /toplevelcache.cfm
		the format is pathinfo - urlinfo - marketingtype
		
		whenever a page is publishd, this controller is called and 
		deletes files that contain info that needs to be refreshed.
	--->
	<cffunction name="init" output="false">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>

	<cffunction name="updateState">
		<cfargument name="params" required="true">
		<cfargument name="siteMapObject" required="true">
				
		<cfparam name="arguments.params.clearsurroundings" default="0">
		
		<!--- system keeps track of paths for replacing when content is displayed. When paths are changed, reload paths data --->
		<cfif arguments.params.clearsurroundings>
			<cfset requestObject.getStateObject().loadPaths(requestObject)>
		</cfif>
        
        <cfif NOT structkeyexists(params,"id")>
        	<cfreturn>
        </cfif>

		<cfset l = structnew()>
		<cfset l.pageid = params.id>
		<cfset l.pageInfo = siteMapObject.getPageInfo(l.pageid)>

		<cfset clearCache(l.pageInfo.urlpath, arguments.params)>
	</cffunction>
	
	<cffunction name="clearCache">
		<!--- 
			Replace here if switch away from file based cacheing 
		--->
		<cfargument name="urlpath" required="true">
		<cfargument name="params" required="true">
		
		<cfset var filteredurlpath = "">
		<cfset var dirlist = "">
		<cfset var finallist = "">
		<cfset var filepath = "">
        
        <cfset urlpath = trim(urlpath)>
        
        <cfif urlpath EQ "">
        	<cfset urlpath = "/">
        </cfif>
		
        <!---<cfset createObject('component','utilities.varlogger').init(
			name="statmgrlog",
			requestObject=requestObject,
        	data="#arguments#"      
		)>--->
		
		<cfdirectory action="list" name="dirlist" directory="#requestObject.getVar('machineroot')#/cache/pages/">

        <cfquery name="dirlist" dbtype="query">
        	SELECT * FROM dirlist WHERE type = 'File'
        </cfquery>
        
		<cfoutput>
       	Clear surroundings = #isdefined("arguments.params.clearsurroundings") AND arguments.params.clearsurroundings#<br>
       
        operating on urlpath = #urlpath#<br>
  		
        <!--- top 3 levels of sitemap get cached on each page in menu. If urlpath is short (2 levels) then clear all cache. --->
        <cfif listlen(urlpath, "/") LTE 2 AND isdefined("arguments.params.clearsurroundings") AND arguments.params.clearsurroundings>
        	 Clearing all items because clearsurroundings = 1 and urlpath listlen lte 2
             <cfloop query="dirlist">
                <cflock name="#dirlist.name#" type="exclusive" timeout="3">
                	<cffile action="delete" file="#requestObject.getVar('machineroot')#/cache/pages/#lcase(dirlist.name)#">
                    deleted #dirlist.name#<br>
                </cflock>
             </cfloop>
             <cfabort>
        </cfif>
        		
        <cfif listlen(urlpath,"/") AND isdefined("arguments.params.clearsurroundings") AND arguments.params.clearsurroundings>
            <cfset filteredurlpath = lcase(rereplace(listdeleteat(urlpath, listlen(urlpath, "/"), "/") & '/', "[^a-zA-Z0-9]", "_", "all"))>	
        <cfelse>
			<cfset filteredurlpath = lcase(rereplace(urlpath, "[^a-zA-Z0-9]", "_", "all"))>	
		</cfif>
        
        filteredurlpath = #filteredurlpath#<br>
        
        <cfquery name="finallist" dbtype="query">
			SELECT name FROM dirlist
			WHERE 
			<cfif arguments.params.clearsurroundings>
				name LIKE '#filteredurlpath#%'
			<cfelse>
				name LIKE '#filteredurlpath#-%'
			</cfif>
		</cfquery>
        
        <cfif finallist.recordcount EQ 0>
        	no records found in finallist.
        </cfif>

		<cfloop query="finallist">
			<cfset filepath = requestObject.getVar('machineroot') & '/cache/pages/' & lcase(finallist.name)>
			<cflock name="#finallist.name#" type="exclusive" timeout="3">
				<cfif fileexists(filepath)>
					<cffile action="delete" file="#filepath#">
                    deleted #finallist.name#<br>
                <cfelse>
                	did not find #finallist.name#<br>
				</cfif>
			</cflock>
		</cfloop>
        
        </cfoutput>
		<cfabort>
	</cffunction>
</cfcomponent>