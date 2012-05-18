<cfcomponent name="loginPage" extends="resources.page">
	
	<cffunction name="preobjectLoad">		
		<cfset var mdl = createobject('component','modules.users.models.users').init(requestObject)>
		<cfset var info = requestObject.getAllFormUrlVars()>
		<cfset variables.vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>

		<cfif requestObject.isformurlvarset('loginForm')>				
			<!--- validate form / log in user --->
			<cfset variables.vdtr = mdl.validateLogin()>		
			<cfif variables.vdtr.passValidation()>
				<cfset mdl.loginUser()>
				<cfif requestObject.getUserObject().isloggedin()>		
					<!--- send user to requested protected page --->
					<cflocation url="#requestObject.getformurlvar('ReturnPage')#" addtoken="false">
				</cfif>
			</cfif>
		</cfif>
		
		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|#variables.pageInfo.title#|">
	</cffunction>
	
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		
		<!--- main title --->
		<!--- <cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('pagetitle', 'simpleContent', data)> --->
		
		<!--- mainContent --->
		<cfset data = structnew()>			
		<cfset data.vdtr = variables.vdtr>
		<cfset data.itemToDisplay = "Login View">
		<cfset data.title = variables.pageInfo.title>		
		
		<cfset addObjectByModulePath('bodyCopy1', 'users', data)>
		
	</cffunction>
</cfcomponent>