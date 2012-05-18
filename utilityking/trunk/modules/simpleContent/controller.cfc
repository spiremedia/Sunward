<cfcomponent name="simplecontent" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data" required="true">
        <cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfif isstruct(data)>
			<cfset variables.data = arguments.data>
		<cfelse>
			<cfset variables.data = structnew()>
			<cfset variables.data.content = arguments.data>
		</cfif>
        
		<cfparam name="variables.data.content" default="">
        
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
        <cfreturn parseForLanguage( variables.data.content )>
	</cffunction>
	
	<cffunction name="showReversionHTML">
        <cfreturn parseforlanguage( showHTML() )>
	</cffunction>
    
    

</cfcomponent>