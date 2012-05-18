<cfcomponent name="change password" extends="resources.page">
	
	<cffunction name="preobjectLoad">	
		<cfset var mdl = createobject('component','modules.users.models.users').init(requestObject)>
		<cfset variables.vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>
		<cfset variables.changePasswordSuccess = 0>

		<cfif requestObject.isformurlvarset('changePasswordForm')>				
			<!--- validate form --->
			<cfset variables.vdtr = mdl.validateChangePassword()>			
			<cfif variables.vdtr.passValidation()>
				<!--- set password --->
				<cfset variables.changePasswordSuccess = mdl.saveChangePassword()>
			</cfif>
		</cfif>
		
		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|#variables.pageInfo.title#|">	
	</cffunction>
	
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		
		<!--- mainContent --->
		<cfset data = structnew()>			
		<cfset data.vdtr = variables.vdtr>
		<cfset data.itemToDisplay = "Change Password View">
		<cfset data.title = variables.pageInfo.title>		
		<cfset data.changePasswordSuccess = variables.changePasswordSuccess>		
		
		<cfset addObjectByModulePath('bodyCopy1', 'users', data)>
		
	</cffunction>
</cfcomponent>