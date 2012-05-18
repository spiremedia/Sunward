<cfcomponent extends="resources.abstractController" ouput="false">
	
	<cffunction name="init" output="false">
		<cfargument name="data">
		<cfargument name="pageref">
		<cfargument name="parameterlist" default="#structnew()#">
		<cfargument name="requestObject">
		<cfset var mdl = createobject('component','modules.users.models.users').init(requestObject)>
			
		<cfparam name="arguments.data.itemToDisplay" default="loginView">
		
		<cfset structappend(variables, arguments.data)>
		
		<cfset variables.ctrl = createObject('component', 'modules.users.views.#replace(arguments.data.itemToDisplay, " ", "", "All")#').init(requestObject, mdl, data)>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfreturn variables.ctrl.showHTML()>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>