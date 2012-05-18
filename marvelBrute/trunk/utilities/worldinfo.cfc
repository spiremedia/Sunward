<cfcomponent name="worldInfo">
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfset variables.requestObj = arguments.requestObj>
		<cfreturn this>
	</cffunction>
	<cffunction name="getStates">
		<cfset var states = "">
		<cfquery name="states" datasource="#variables.requestObj.getVar('dsn')#">
			SELECT abbrev, name FROM usstates
		</cfquery>
		<cfreturn states>
	</cffunction>
	<cffunction name="getCountries">
		DOOO SOMETHING!
	</cffunction>
</cfcomponent>