<cfcomponent ouput="false">
	<cffunction name="init" output="false">
    	<cfargument name="requestObject">
		<cfargument name="mdl">
		<cfargument name="data">
		
        <cfset variables.requestObject = arguments.requestObject>
		<cfset variables.mdl = arguments.mdl>		
		<cfset variables.data = arguments.data>		
        <cfreturn this>
    </cffunction>
	
    <cffunction name="showHTML" output="false">
		<cfif requestObject.isformurlvarset('loginForm') AND variables.data.vdtr.passValidation() AND requestObject.getUserObject().getFirstTimeUser()>
			<cfreturn showFirstTimeUserHTML()>
		<cfelse>
			<cfreturn showFormHTML()>
		</cfif>
    </cffunction>
	
    <cffunction name="showFirstTimeUserHTML" output="false">
		<cfset var lcl = structnew()>
					
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<cfoutput>
					<p>
						Thanks for logging in. An email has been sent to the email address on file, please click the link to complete the login process.
					</p>
				</cfoutput>
			</div>
	    </cfsavecontent>
		<cfreturn lcl.html>
    </cffunction>
	
    <cffunction name="showFormHTML" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.intro = "">
		<cfset lcl.ReturnPage = "/">
		
		<cfif requestObject.isformurlvarset('ReturnPage')>
			<cfset lcl.ReturnPage = requestObject.getformurlvar('ReturnPage')>
		</cfif>

		<cfset lcl.intro = lcl.intro & "<h2>PLEASE LOG IN</h2>">
		
		<cfset lcl.form = createObject('component', 'resources.abstractController').getUtility('formbuilder').init(requestObject,"LoginForm",'Post',data.vdtr)>		
		<cfset lcl.form.addFormItem('loginForm', '', 'hidden', '1')>
		<cfset lcl.form.addFormItem('ReturnPage', '', 'hidden', lcl.ReturnPage)>
		<cfset lcl.form.addFormItem('usr', 'Username:', 'text')>
		<cfset lcl.form.addFormItem('pd', 'Password:', 'password')>
		<cfset lcl.form.addSubmit('submit','', 'Submit')>
					
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<cfoutput>
					#lcl.intro#
					#lcl.form.showHTML()#
					<!--- <cfif requestObject.getUserObject().isloggedin()>
						<cfdump var="#requestObject.getUserObject().dump()#">
					</cfif> --->
				</cfoutput>
			</div>
	    </cfsavecontent>
		
    	<cfreturn lcl.html>
    </cffunction>
</cfcomponent>