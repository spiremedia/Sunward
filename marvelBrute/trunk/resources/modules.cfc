<cfcomponent name="modules">
	<!--- COMMENT: 
			I manage all of the templates for each module and action including discovering from xml
			I dispatch events by packaging the required templates into a display Object
	--->
	<cffunction name="init">
		<cfargument name="machineRoot">
		<cfset var dirinfo = "">
		<cfset var filepath = arguments.machineRoot & '/modules/'>
		<cfset var dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(filepath)>
		
		<cfset variables.mymodules = structnew()>
		
		<cfloop query="dirs">
			<cfset addmodule(name)>
		</cfloop>
	
		<cfreturn this/>
	</cffunction>

	<cffunction name="addmodule">
		<cfargument name="name" required="true">
		<cfset variables.mymodules[name] = 1>
	</cffunction>
	
	<cffunction name="getmodules">
		<cfreturn structkeylist(variables.mymodules)>
	</cffunction>
	
	<cffunction name="getModule">
		<cfargument name="module" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="parameterlist" required="true">
		<cfargument name="pageref">
		<cfargument name="possibleModules">
		<cfargument name="data" default="#structnew()#">
        <cfargument name="name" default="blank">
		
		<cfif NOT structkeyexists(variables.mymodules,module)>
			<cfthrow message="module '#module#' is not in modules in application scope. Please reload and or add module directory">
		</cfif>
		
		<cfreturn createObject('component','modules.' & module & '.controller').init(	
					requestObject = requestObject,
					parameterList = arguments.parameterList,
					pageref = arguments.pageref,
					possibleModules = arguments.possiblemodules,
					data = data, 
                    name = name)>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.mymodules#><cfabort>
	</cffunction>
</cfcomponent>