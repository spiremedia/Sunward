<cfcomponent name="abstract module controller">
	<cffunction name="getResource">
		<cfargument name="name" required="true">
		<cfset var rs = createObject('component', 'resources.#name#')>
		<cfreturn rs>
	</cffunction>
	<cffunction name="getUtility">
		<cfargument name="name" required="true">
	
		<cfset ut = createObject('component', 'utilities.#name#')>
		
		<cfreturn ut>
	</cffunction>
	<cffunction name="notEmpty">
		<cfreturn true>
	</cffunction>
	<cffunction name="getCacheLength">
		<cfreturn 20>
	</cffunction>
</cfcomponent>