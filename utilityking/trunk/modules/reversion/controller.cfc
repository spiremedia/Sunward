<cfcomponent extends="resources.abstractController" ouput="false">

	<cffunction name="init" output="false">
		<cfargument name="data" default="#structnew()#">
		<cfargument name="pageref">
		<cfargument name="parameterlist" default="">
		<cfargument name="requestObject">
	
		<cfset var modulexml = "">
		<cfset var lcl = structnew()>
		
		<cfreturn this>
	</cffunction>

</cfcomponent>