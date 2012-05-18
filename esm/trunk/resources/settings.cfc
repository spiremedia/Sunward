<cfcomponent name="settings">
	<cffunction name="init">
		<cfset var fs = "">
		
		<cfset variables.settings = structnew()> 
		<cfset variables.settings.machineRoot = GetDirectoryFromPath( GetBaseTemplatePath() )>
		
		<cfif findnocase('win',server.os.name)>
			<cfset variables.settings.pathdelimiter = '\'>
		<cfelse>
			<cfset variables.settings.pathdelimiter = '/'>
		</cfif>
		
		<cfset loadini("/resources/settings.cfm")>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="loadini">
		<cfargument name="path">

		<cfset fs = createObject('component','utilities.filesystem').iniparser(variables.settings.machineRoot & arguments.path)>
		
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
		<cfset var requestObj = createObject('component','request').init()>

		<cfloop collection="#variables.settings#" item="itm">
			<cfset requestObj.setVar(itm, variables.settings[itm])>
		</cfloop>
		
		<cfreturn requestObj>
	</cffunction>
</cfcomponent>