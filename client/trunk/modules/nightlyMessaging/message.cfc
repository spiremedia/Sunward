<cfcomponent name="message">
	<!--- this is a value object for a message --->
	<cffunction name="init">
    	<cfargument name="requestObject">
        <cfargument name="type" default="email">
        <cfreturn this>
    </cffunction>
    
    <cffunction name="setRecipient">
    	<cfargument name="recip">
    	<cfset variables.recipient = arguments.recip>
    </cffunction>
    
    <cffunction name="getRecipient">
    	<cfreturn variables.recipient>
    </cffunction>
    
    <cffunction name="setSubject">
    	<cfargument name="sub">
    	<cfset variables.subject = arguments.sub>
    </cffunction>
    
    <cffunction name="getSubject">
    	<cfreturn variables.subject>
    </cffunction>
    
    <cffunction name="setBody">
    	<cfargument name="bdy">
    	<cfset variables.body = arguments.bdy>
    </cffunction>
    
    <cffunction name="getBody">
    	<cfreturn variables.body>
    </cffunction>
    
</cfcomponent>