<cfcomponent name="user controller" output="false" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
        <cfargument name="parameterlist" default="">
		<cfargument name="pageRef">

		<cfset variables.requestObject = arguments.requestObject>
		
		<cfif structkeyexists(parameterlist, 'embededform')> 
	      	<cfset variables.controller = createObject('component', "modules.users.formController").init(requestObject = requestObject)>
        <cfelse>
        	<cfset variables.controller = createObject('component', "modules.users.loginPageController").init(requestObject = requestObject)>
        </cfif>
        
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
    	<cfreturn variables.controller.showHTML()>
	</cffunction>
    	
	<cffunction name="dump">
		<cfset variables.controller.dump()>
	</cffunction>
    
    <cffunction name="getCacheLength">
		<cfreturn variables.controller.getCacheLength()>
	</cffunction>
</cfcomponent>