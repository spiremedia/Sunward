<cfcomponent name="localuser" extends="resources.defaultuser" output="false">
	
	<cffunction name="init">
		<cfset super.init()>
        <cfset variables.onSuccessfullLoginLocation = '/'>
		<cfreturn this>
	</cffunction>
	
    <cffunction name="setLoginErrors">
    	<cfargument name="loginErrors" required="true">
        <cfset variables.loginErrors = loginErrors>
    </cffunction>
    
    <cffunction name="getLoginErrors">
    	<cfif isdefined("variables.loginErrors")>
        	<cfreturn variables.loginErrors>
        </cfif>
    	<cfreturn ''>
    </cffunction>
    
    <cffunction name="successFulLogin">
       	<cfreturn variables.onSuccessfullLoginLocation>
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
 
    <cffunction name="SetLoginRelocationPath">
    	<cfargument name="path" required="true">
        <cfset variables.wantstogo = path>
    </cffunction>
    
    <cffunction name="getLoginRelocationPath">
    	<cfif isdefined("variables.wantstogo")>
        	<cfreturn variables.wantstogo>
        <cfelse>
        	<cfreturn "/">
        </cfif>
    </cffunction>
	
	
	<cffunction name="redirectLogin" output="False">
		<cfargument name="reason" default="">
		<cfargument name="view" default="normal">
		
		<cfif arguments.view EQ 'normal'>
			<cflocation url="/Users/Login/?reason=#reason#&continueURL=#getLoginRelocationPath()#" addtoken="no">
		<cfelse>
			<cfcontent reset="true">redirectLogin<cfabort>
		</cfif>
	</cffunction>
	
</cfcomponent>