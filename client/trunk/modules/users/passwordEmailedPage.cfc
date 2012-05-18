<cfcomponent name="passwordEmailedPage" extends="resources.page">
	
	<cffunction name="preobjectLoad">	
		<cfset var lcl = structNew()>
		<cfset var mdl = createobject('component','modules.users.models.users').init(requestObject)>
	
		<cfset lcl.recipient = requestObject.getUserObject().getForgotPwdRecipient()>
		<cfif lcl.recipient neq ''>			
			<cfset mdl.resetForgotPassword(recipient = lcl.recipient)>
		<cfelse>
			An error has occurred. Please try again <a href="/login/">here</a>
			<cfabort>
		</cfif>
		
		<cfset variables.pageInfo.title = "Password Emailed">
		<cfset variables.pageInfo.pagename = "Password Emailed">
	</cffunction>
	
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		
		<!--- main title --->
		<cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('pagetitle', 'simpleContent', data)>
		
		<!--- mainContent --->
		<cfset data = structnew()>			
		<cfset data.itemToDisplay = "Password Emailed View">
		<cfset data.title = variables.pageInfo.title>		
		
		<cfset addObjectByModulePath('bodyContentItem1', 'users', data)>
		
	</cffunction>
</cfcomponent>