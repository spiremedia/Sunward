<cfcomponent name="Users" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfset var pagename = ''>
		<cfset var arrError = arrayNew(1)>
		<cfset var arrPageName = arrayNew(1)>
		
        <cfset variables.userObject = requestObject.getUserObject()>
		
		<cfif NOT variables.userObject.isLoggedIn()>
			<cfset pagename = 'Login Page'>
		</cfif>
		
		<!--- possible error codes: --->
		<cfset arrError[1] = "Please log in to access this section of the Web site.  If you have difficulty accessing or creating your account, please contact FPA Member Services at 800.322.4237 (U.S. & Canada) or 303.759.4900 (International).">
		<cfset arrError[2] = "You do not have access rights to this section of the Web site.  To gain access, please contact FPA Member Services at 800.322.4237 (U.S. & Canada) or 303.759.4900 (International).">
		<cfset arrPageName[1] = "Login Page">
		<cfset arrPageName[2] = "Access Denied">
		<cfset variables.errorMessage = ''>
		
		<cfif requestObject.isFormUrlVarSet('reason') 
			AND isNumeric(requestObject.getFormUrlVar('reason')) 
				AND requestObject.getFormUrlVar('reason') gt 0
					AND ArrayLen(arrError) gte requestObject.getFormUrlVar('reason')>
			<cfset variables.errorMessage = arrError[requestObject.getFormUrlVar('reason')]>
			<cfset pagename = arrPageName[requestObject.getFormUrlVar('reason')]>
		</cfif>
		
        <cfset variables.pageinfo.breadcrumbs = "Home|User">
        <cfset variables.pageinfo.pagename = pagename>
		
    </cffunction>
	
    <cffunction name="postObjectLoad">
		<cfset var contentarea1 = "">
		<cfset var contentarea2 = "">
		
 		<cfswitch expression="#requestObject.getVar('siteid')#">
			<!--- Journal --->
			<cfcase value="AD1724FF-E347-83EA-18FD424840AD5849">
				<cfset contentarea1 = "middleContentItem2">
				<cfset contentarea2 = "middleContentItem2a">
			</cfcase>   
			<!--- Consumer
			<cfcase value="1DECB6D8-E0B8-ABF4-77D2D52C2CC9D459">
				<cfset contentarea1 = "pageContent">
				<cfset contentarea2 = "pageContent2">
			</cfcase>    --->
			<!--- Member or Annual Conference --->
			<cfdefaultcase> 
				<cfset contentarea1 = "middleItem5">
				<cfset contentarea2 = "middleItem5b">
   			</cfdefaultcase> 
		</cfswitch> 
		
		<!--- contentarea1 --->
		<cfset data = structnew()>
		<cfset data.content = '<p>#variables.errorMessage#</p>'>
		<cfset addObjectByModulePath(contentarea1, 'HTMLContent', data)>
		
		<!--- contentarea2 --->
		<cfset data = structnew()>
		<cfif NOT variables.userObject.isLoggedIn()>
			<cfsavecontent variable="data">
				<cfoutput>
					<div class="userLoginForm">
						[postprocess-usershtml]
					</div>
				</cfoutput>
			</cfsavecontent>
			<cfset addObjectByModulePath(contentarea2, 'HTMLContent', data)>
		</cfif>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>