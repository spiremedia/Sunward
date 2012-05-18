<cfcomponent name="logoutPage" extends="resources.page">
	
	<cffunction name="preobjectLoad">		
		<!--- delete user's session --->
		<cfset requestObject.getUserObject().init()>	
		<!--- redirect user to main page --->
		<cflocation url="/" addtoken="false">
		<cfabort>
	</cffunction>
</cfcomponent>