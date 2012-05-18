<cfcomponent name="request" output="false"><!--- extends registry? --->

	<cffunction name="init" output="false">
		<cfset variables.requestvars = duplicate(cookie)>
		
		<cfset structappend(variables.requestvars, url)>
		<cfset structappend(variables.requestvars, form)>
		
		<!-- remove first slashes on path -->
		<cfif isdefined("variables.requestvars.path")>
			<cfset variables.requestvars.path = rereplace(variables.requestvars.path,'^/+','')>
			<cfif not refind('/$', variables.requestvars.path)>
				<cfset variables.requestvars.path = variables.requestvars.path & '/'>
			</cfif>
		</cfif>
		
		<cfset variables.v = structnew()>
		<cfset variables.v.requestTimeStamp = now() + 0>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setvar" output="false">
		<cfargument name="name">
		<cfargument name="value">
		
		<cfif structkeyexists(variables.v, name)>
			<cfthrow message="'#name#' already exists in request">
		</cfif>
		
		<cfset variables.v[name] = value>
	</cffunction>
	
	<cffunction name="getvar" output="false">
		<cfargument name="name">
				
		<cfif not structkeyexists(variables.v, name)>
			<cfthrow message="'#name#' not set in request">
		</cfif>
		
		<cfreturn variables.v[name]>
	</cffunction>
	
	<cffunction name="isvarset" output="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.v, name)>
	</cffunction>
	
	<cffunction name="isformurlvarset" output="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.requestvars, arguments.name)>
	</cffunction>
	
	<cffunction name="getformurlvar" output="false">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.requestvars, arguments.name)>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn htmleditformat(variables.requestvars[arguments.name])>
	</cffunction>
    
    <cffunction name="getunsafeformurlvar" output="false">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.requestvars, arguments.name)>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn variables.requestvars[arguments.name]>
	</cffunction>

	<cffunction name="getallformurlvars" output="false">
    	<cfset var dupvars = duplicate(variables.requestvars)>
        <cfset var idx = "">
        <cfloop collection="#dupvars#" item="idx">
        	<cfset dupvars[idx] = htmleditformat(dupvars[idx])>
        </cfloop>
		<cfreturn dupvars>
	</cffunction>
	
	<cffunction name="getUrlIdentifyer">
		<!--- this regex removes url variables path, reset and refresh from the cgi.querystring --->
		<cfset var t = rereplacenocase(cgi.QUERY_STRING, "(path|&reset|&refresh)[^&]*","","all")>
		<!--- concat escaped path and remaining escaped url vars --->
		<cfset t = rereplace(getFormUrlVar('path'), "[^a-zA-Z0-9]", "_","all") & "-" & rereplace(t, "[^a-zA-Z0-9]", "_","all")>
       	<!--- add marketing type to keep seperate caches --->
		<cfset t = t & '-' & session.user.getMemberType()>

		<!--- bye bye --->
		<cfreturn t>
	</cffunction>
	
    <cffunction name="getUserObject" output="false">
		<cfreturn session.user>
	</cffunction>
    
    <cffunction name="getStateObject" output="false">
		<cfreturn variables.stateObject>
	</cffunction>
    
    <cffunction name="setStateObject" output="false">
		<cfargument name="stateObject" required="true">
        <cfset variables.stateObject = arguments.stateObject>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var m = structnew()>
		<cfset m.requestvars = requestvars>
		<cfset m.setvars = v>
		<cfdump var=#m#>
		<cfabort>
	</cffunction>
	
</cfcomponent>