<cfcomponent name="blankEditable">
	
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfargument name="parameterList">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.parameterList = arguments.parameterList>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var contents="">
		<cfreturn contents>
	</cffunction>
	<cffunction name="notEmpty">
		<cfreturn false>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 10000>
	</cffunction>

</cfcomponent>