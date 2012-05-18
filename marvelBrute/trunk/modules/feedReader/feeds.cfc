<cfcomponent name="feeds" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setUrl">
		<cfargument name="feedurl" required="true">
		<cfset variables.feedurl = arguments.feedurl>
	</cffunction>
	
	<cffunction name="getFeed">
		<cfset var p = structnew()>
		<cfif variables.feedurl NEQ "">

        	<cftry>
                <cffeed source = "#trim(variables.feedurl)#" 
                    properties = "variables.properties" 
                    	query = "variables.query" timeout="10">
               
                <cfset p.properties = variables.properties>
                <cfset p.query = variables.query>

                <cfcatch>
                	
                   	<cfset p.properties = "">
                    <cfset p.query = "">
                </cfcatch>    
			</cftry>
		
		<cfelse>
			<cfset p.properties = "">
			<cfset p.query = "">
		</cfif>
		<cfreturn p/>
	</cffunction>
	
</cfcomponent>