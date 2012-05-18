<cfcomponent name="request" extends="resources.registry" output="false">

	<cffunction name="init">
		<cfset var itm = "">
		<cfset variables.requestvars = url>
		<cfset structappend(variables.requestvars, form)>
		<cfloop collection="#variables.requestvars#" item="itm">
			<cfset variables.requestvars[itm] = trim(variables.requestvars[itm])>
		</cfloop>
		<cfset variables.v = structnew()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModuleFromPath" output="false">
		<cfif structkeyexists(variables.requestvars,'module')>
			<cfreturn variables.requestvars.module>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>
	
	<cffunction name="getActionFromPath">

		<cfif structkeyexists(variables.requestvars,'action')>
			<cfreturn variables.requestvars.action>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cffunction>
	
	<cffunction name="getMachineRoot">
		<cfreturn GetDirectoryFromPath(GetCurrentTemplatePath())>
	</cffunction>


	<cffunction name="isformurlvarset">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.requestvars, arguments.name)>
	</cffunction>
	
	<cffunction name="getformurlvar" output="false">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.requestvars, arguments.name)>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn variables.requestvars[arguments.name]>
	</cffunction>
	
	<cffunction name="getallformurlvars">
		<cfreturn duplicate(variables.requestvars)>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var m = structnew()>
		<cfset m.formurl = variables.requestvars>
		<cfset m.set = variables.v>
		<cfdump var="#m#">
	</cffunction>
	
</cfcomponent>