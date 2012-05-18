<cfcomponent name="access denied" extends="resources.page">
	
	<cffunction name="preobjectLoad">			
		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|#variables.pageInfo.title#|">	
	</cffunction>
	
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		
		<!--- mainContent --->
		<cfset data = structnew()>			
		<cfset data.itemToDisplay = "Access Denied View">
		<cfset data.title = variables.pageInfo.title>		
		
		<cfset addObjectByModulePath('bodyCopy1', 'users', data)>
		
	</cffunction>
</cfcomponent>