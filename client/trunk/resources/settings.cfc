<cfcomponent name="settings">
	<cffunction name="init">
    	<cfargument name="stateObject" required="true">
		<cfset  var fs = "">
		<cfset  var tmp = GetDirectoryFromPath( GetCurrentTemplatePath() )>
		<cfset variables.settings = structnew()> 
		
		<cfif findnocase('win',server.os.name)>
			<cfset variables.settings.pathdelimiter = '\'>
		<cfelse>
			<cfset variables.settings.pathdelimiter = '/'>
		</cfif>
		
		<cfset variables.settings.machineRoot = listdeleteat(tmp,listlen(tmp,variables.settings.pathdelimiter),variables.settings.pathdelimiter)>
		
		<cfset loadini("/resources/settings.cfm")>
		
		<cfset variables.stateObject = arguments.stateObject>
		<!--- <cfset variables.stateObject.setVar('dsn', variables.settings.dsn)> --->
        
        <cfreturn this>
	</cffunction>
	
	<cffunction name="loadini">
		<cfargument name="path">

		<cfset var fs = createObject('component','utilities.filesystem').iniparser(variables.settings.machineRoot & arguments.path)>
		
		<cfif findnocase("windows", server.os.name)>
			<cfset variables.settings.filedelim = '\'>
		<cfelse>
			<cfset variables.settings.filedelim = '/'>
		</cfif>
		
		<cfset structappend(variables.settings, fs)>
	</cffunction>
	
	<cffunction name="setvar">
		<cfargument name="name">
		<cfargument name="value">
		
		<cfif structkeyexists(variables.settings, name)>
			<cfthrow message="#name# already exists in request">
		</cfif>
		
		<cfset variables.settings[name] = value>
	</cffunction>
	
	<cffunction name="getvar">
		<cfargument name="name">
				
		<cfif not structkeyexists(variables.settings, name)>
			<cfthrow message="'#name#' does not exists in settings">
		</cfif>
		
		<cfreturn variables.settings[name]>
	</cffunction>
	
	<cffunction name="isvarset">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.settings, name)>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.settings#><cfabort>
	</cffunction>
	
	<cffunction name="makeRequestObject">
		<cfset var itm = "">
		<cfset var requestObj = createObject('component','resources.request').init()>

		<cfloop collection="#variables.settings#" item="itm">
			<cfset requestObj.setVar(itm, variables.settings[itm])>
		</cfloop>
        
        <cfset requestObj.setStateObject(variables.stateObject)>
		
		<cfreturn requestObj>
	</cffunction>
</cfcomponent>