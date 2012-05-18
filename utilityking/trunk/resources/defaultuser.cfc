<cfcomponent name="defaultuser" output="False">
	
	<cffunction name="init" output="False">		
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
	
	<cffunction name="getUserID" output="False">
		<cfreturn variables.id>
	</cffunction>
	
	<cffunction name="getUsername" output="False">
		<cfreturn variables.username>
	</cffunction>

	<cffunction name="getFirstName" output="False">
		<cfreturn variables.fname>
	</cffunction>
	
	<cffunction name="getLastName" output="False">
		<cfreturn variables.lname>
	</cffunction>
	
	<cffunction name="getFullName" output="False">
		<cfreturn variables.fname & ' ' & variables.lname>
	</cffunction>
	
	<cffunction name="dump" output="False">
		<cfdump var=#variables#>
	</cffunction>
	
	<cffunction name="relogin" output="False">
		<cfargument name="reason" default="">
		<cfargument name="view" default="normal">
		
		<cfset logout()>
		
		<cfif arguments.view EQ 'normal'>
			<cflocation url="/Users/Login/?logout&reason=#reason#" addtoken="no">
		<cfelse>
			<cfcontent reset="true">relogin<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="logout">
		<cfset structdelete(variables,'id')>
	</cffunction>
	
	<cffunction name="isloggedin" output="False">
		<cfif structkeyexists(variables, 'id') 
				AND variables.id NEQ "">
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
</cfcomponent>