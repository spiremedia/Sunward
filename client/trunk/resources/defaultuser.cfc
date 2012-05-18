<cfcomponent name="defaultuser" output="False">
	
	<cffunction name="init" output="False">		
		<cfset setUserID(id = '')>	
		<cfset setUsername(username = '')>	
		<cfset setFirstName(fname = '')>	
		<cfset setLastName(lname = '')>	
		<cfset setMemberType(type = '')>	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setUsername" output="False">
		<cfargument name="username">
		<cfset variables.username = arguments.username>
	</cffunction>
	
	<cffunction name="setFirstName" output="False">
		<cfargument name="fname">
		<cfset variables.fname = arguments.fname>
	</cffunction>
	
	<cffunction name="setLastName" output="False">
		<cfargument name="lname">
		<cfset variables.lname = arguments.lname>
	</cffunction>
	
	<cffunction name="setUserID" output="False">
		<cfargument name="id">
		<cfset variables.id = arguments.id>
	</cffunction>
    
    <cffunction name="setMemberType">
    	<cfargument name="type" required="true">
        <cfset variables.membertype = type>
    </cffunction>

    <cffunction name="getMemberType" output="false">
		<cfif isdefined("variables.membertype")>
        	<cfreturn variables.membertype>
        </cfif>
    	<cfreturn 'default'>
    </cffunction>	
	
	<cffunction name="getUserID" output="False">
		<cfif isdefined("variables.id")>
        	<cfreturn variables.id>
        </cfif>
    	<cfreturn ''>
	</cffunction>
	
	<cffunction name="getUsername" output="False">
		<cfif isdefined("variables.username")>
        	<cfreturn variables.username>
        </cfif>
    	<cfreturn ''>
	</cffunction>

	<cffunction name="getFirstName" output="False">
		<cfif isdefined("variables.fname")>
        	<cfreturn variables.fname>
        </cfif>
    	<cfreturn ''>
	</cffunction>
	
	<cffunction name="getLastName" output="False">
		<cfif isdefined("variables.lname")>
        	<cfreturn variables.lname>
        </cfif>
    	<cfreturn ''>
	</cffunction>
	
	<cffunction name="getFullName" output="False">
		<cfreturn getFirstName() & ' ' & getLastName()>
	</cffunction>
		
	<cffunction name="dump" output="False">
		<cfdump var=#variables#><cfabort>
	</cffunction>
	
	<cffunction name="logout">
		<cfif isdefined("variables.id")>
        	<cfset structdelete(variables,'id')>
        </cfif>
	</cffunction>
	
	<cffunction name="isloggedin" output="False">
		<cfif structkeyexists(variables, 'id') AND variables.id NEQ "">
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
		
</cfcomponent>