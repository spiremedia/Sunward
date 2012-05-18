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
		<cfif requestObject.isformurlvarset('changePasswordForm') AND variables.data.vdtr.passValidation()>
			<cfif variables.data.changePasswordSuccess>
				<cfreturn showSuccessHTML()>
			<cfelse>
				<cfreturn showFailHTML()>
			</cfif>
		<cfelse>
			<cfreturn showFormHTML()>
		</cfif>
    </cffunction>
	
    <cffunction name="showSuccessHTML" output="false">
		<cfset var lcl = structnew()>
					
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<cfoutput>
					<p>
						Your password has been changed successfully. 
						<cfif NOT requestObject.getUserObject().isloggedin()>
							Click <a href="/Users/Login/">here</a> to login.
						</cfif>
					</p>
				</cfoutput>
			</div>
	    </cfsavecontent>
		<cfreturn lcl.html>
    </cffunction>
	
    <cffunction name="showFailHTML" output="false">
		<cfset var lcl = structnew()>
					
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<cfoutput>
					<p class="msg">
						Operation failed. Your password could not be changed. 
						Please try again by clicking the link in your First Time User Email or call 1-888-898-3091 for support.  
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
		<cfset lcl.memberid = "">
		
		<cfif requestObject.isformurlvarset('ReturnPage')>
			<cfset lcl.ReturnPage = requestObject.getformurlvar('ReturnPage')>
		</cfif>
		<cfif requestObject.isformurlvarset('mid')>
			<cfset lcl.memberid = requestObject.getformurlvar('mid')>
		</cfif>

		<cfset lcl.intro = lcl.intro & "<h2>PLEASE CHANGE YOUR PASSWORD</h2>">
		
		<cfset lcl.form = createObject('component', 'resources.abstractController').getUtility('formbuilder').init(requestObject,"LoginForm",'Post',data.vdtr)>		
		<cfset lcl.form.addFormItem('changePasswordForm', '', 'hidden', '1')>
		<cfset lcl.form.addFormItem('memberid', '', 'hidden', lcl.memberid)>
		<cfset lcl.form.addFormItem('ReturnPage', '', 'hidden', lcl.ReturnPage)>
		<cfset lcl.form.addFormItem('newpd', 'New Password:', 'password')>
		<cfset lcl.form.addFormItem('verifynewpd', 'Re-enter New Password:', 'password')>
		<cfset lcl.form.addSubmit('submit','', 'Submit')>
					
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<cfoutput>
					#lcl.intro#
					#lcl.form.showHTML()#
				</cfoutput>
			</div>
	    </cfsavecontent>
		
    	<cfreturn lcl.html>
    </cffunction>
</cfcomponent>