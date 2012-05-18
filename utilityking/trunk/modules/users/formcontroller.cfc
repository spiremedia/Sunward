<cfcomponent name="user controller" output="false" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
        <cfargument name="parameterlist">
		<cfargument name="pageRef">

		<cfset variables.requestObject = arguments.requestObject>

		<cfreturn this>
	</cffunction>
	
    <cffunction name="showHTML" output="false">
    	<cfset var me = "">
        <cfset var userObj = requestObject.getUserObject()>
        <cfset var loginErrors = userObj.getLoginErrors()>
        <cfset var pageLocation = requestObject.getformurlvar('path')>
        <cfset var indx = "">
        <cfset var sites = structnew()>
		<cfset var lcl = structnew()>
		
		
		<!--- clear validation errors --->
		<cfset userObj.setLoginErrors('')>

		<cfsavecontent variable="me">
        <cfoutput>
		<cfif userObj.isLoggedIn()>
            Hi #userObj.getFullName()#<br><br/>
            <!--- You are in the marketinggroup : #userObj.getMarketingType()#<br>
            You are in the membergroup : #userObj.getMemberType()#<br/>
            You are in the securityrole : #arraytolist(userObj.getImisSecurityRoles())#<br/>
            You are in Chapter : #userObj.getChapterDomain()#<br/>
			My token is #userObj.getImisToken()# <br/> --->
           <a href="?logout">Logout</a>
        <cfelse>
			
			<cfif requestObject.isFormUrlVarSet('continueURL')>
				<cfset pageLocation = requestObject.getFormUrlVar('continueURL')>
			</cfif>
			
			<cfif left(pageLocation,1) neq '/' AND left(pageLocation,4) neq 'http'>
				<cfset pageLocation = "/" & pageLocation>
			</cfif>
			
			<cfcookie name="cookiesenabled" value="1" expires="#dateformat(dateadd('d',1,now()),"mm/dd/yyyy")#">
            <div class="loginForm">
                <form action="#pageLocation#" method="post">
                 <cfif loginErrors neq ''>
                    <p>#loginErrors#</p>
                </cfif>
                <p>
                <label for="un">User Name</label><input id="un" name="un" type="text" maxlength="20" style="width:85px" />
                </p>
                <p>
                <label for="pd">Password</label><input id="pd" name="pd" type="password" maxlength="20" style="width:85px"/>
                </p>
          
                <p>
                <label for="sbmit">&nbsp;</label><input id="sbmit" type="image" src="/ui/images/loginButton.gif" class="submitImage" />
                </p>
                </form>
            </div>
        </cfif>
		
        </cfoutput>
        </cfsavecontent>
        <cfreturn me>
	</cffunction>
    
</cfcomponent>