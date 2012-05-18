<cfcomponent name="localuser" extends="resources.defaultuser" output="false">
	
	<cffunction name="init">
		<cfset super.init()>
		<cfset setFirstTimeUser(user_firsttime = 0)>	
		<cfset setName(name = '')>	
		<cfreturn this>
	</cffunction>
    
    <cffunction name="setFirstTimeUser">
    	<cfargument name="user_firsttime" required="true">
        <cfset variables.user_firsttime = arguments.user_firsttime>
    </cffunction>

    <cffunction name="getFirstTimeUser" output="false">
		<cfif isdefined("variables.user_firsttime")>
        	<cfreturn variables.user_firsttime>
        </cfif>
		<cfreturn 0>
    </cffunction>	
	
	<cffunction name="setName" output="False">
		<cfargument name="name">
		<cfset variables.name = arguments.name>
	</cffunction>
	
	<cffunction name="getName" output="False">
		<cfif isdefined("variables.name")>
        	<cfreturn variables.name>
        </cfif>
    	<cfreturn ''>
	</cffunction>
	
	<cffunction name="setEmail" output="False">
		<cfargument name="email">
		<cfset variables.email = arguments.email>
	</cffunction>
	
	<cffunction name="getEmail" output="False">
		<cfif isdefined("variables.email")>
        	<cfreturn variables.email>
        </cfif>
    	<cfreturn ''>
	</cffunction>
   
   <cffunction name="loadCredentials">
		<cfargument name="requestObject" required="true">
		<cfargument name="user" required="true">
		
		<cfset setUserID(user.id)>				
		<cfset setUserName(user.username)>	
		<cfset setName(user.name)>	
		<cfset setEmail(user.email)>	
		<cfset setMemberType(user.MemberTypes)>	
		<cfset setFirstTimeUser(user.firsttimeuser)>	
   </cffunction>
</cfcomponent>