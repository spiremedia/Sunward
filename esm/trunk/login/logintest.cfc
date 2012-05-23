<cfcomponent displayname="loginTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','utilities.http').init()>
		<cfset variables.httpObj.setHost("http://#cgi.HTTP_HOST#")>
	</cffunction>
	
	<cffunction name="getLoggedInSAUser">
		<cfset setup()>
		
		<cfset variables.httpObj.setPath("/login/checkLogin/")>
		
		<cfset variables.httpObj.addFormField('username', "sa@spiremedia.com")>
		<cfset variables.httpObj.addFormField('password', "bvRocks")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.cookies = response.getCookies()>
		
		<cfloop collection="#l.cookies#" item="l.cookie">
			<cfset variables.httpObj.addCookie(l.cookie, l.cookies[l.cookie].val)>
		</cfloop>
		
		<cfset variables.httpObj.clear()>
		<cfif response.existsbypattern("choosesite")>
			<cfset variables.httpObj.setPath("/login/chooseSite/")>
			<cfset response = variables.httpObj.load()>
			<cfset assertfalse(condition=(response.didError()),message="Error seeing choose site")>
			<cfset l.link = response.getByPattern("/login/startPage/\?switchsiteid\=[A-Z0-9\-]{35}")>
			<cfset variables.httpObj.setPath(l.link)>
			<cfset response = variables.httpObj.load()>
			<cfset assertfalse(condition=(response.didError()),message="Error choosing site")>
		</cfif>

		<cfreturn variables.httpObj>
	</cffunction>
	
	<cffunction name="teardown">
		
	</cffunction>
	
    <cffunction name="testlogin">
		<cfset var l = structnew()>
		<cfset var response = "">
		
		<cfset variables.httpObj.setPath("/login/loginForm/")>
		<cfset response = variables.httpObj.load()>
		<cfset l.cookies = response.getCookies()>
		
		<cfloop collection="#l.cookies#" item="l.cookie">
			<cfset variables.httpObj.addCookie(l.cookie, l.cookies[l.cookie].val)>
		</cfloop>

		<!--- test there is username and password form fields on page --->
		<cfset l.formFields = response.getESMFormFields()>

		<cfset asserttrue(condition=(listfindnocase(l.formFields,"username") AND listfindnocase(l.formfields, "password")),message="incorrect form : should have username and password")>

		<!--- try to login as wrong user --->
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.clear('formfield,urlfields,url')>
				
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.addFormField('username', "test")>
		<cfset variables.httpObj.addFormField('password', "fred")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.existsByPattern('validation')),message="User able to incorrectly login")>
		
		<cfset variables.httpObj.addFormField('username', "sa@spiremedia.com")>
		<cfset variables.httpObj.addFormField('password', "bvRocks")>
		
		<cfset response = variables.httpObj.load()>

		<cfif response.existsByPattern('validation') OR NOT response.isESMRelocate()>
			<cfset fail(message="sa unable to login")>
		</cfif>
	</cffunction>
	
</cfcomponent>
		