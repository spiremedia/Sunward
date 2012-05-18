<cfcomponent displayname="loginTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM users WHERE username like '%gazook%'
		</cfquery>
		<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
			DELETE FROM users_log WHERE description like '%gazook%'
		</cfquery>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/Users/StartPage/')>
		<cfset response = variables.httpObj.load()>
		<cfdump var="#response#"><cfabort>

		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see users")>
		
		
	<!--- testing add page --->
		<cfset variables.httpObj.setPath('/Users/AddUser/')>
		<cfset response = variables.httpObj.load()>
		
		<cfset l.formFields = response.getESMFormFields()>
		
		<cfset assertfalse(condition=(len(l.formFields) EQ 0),message="no form fields in add page")>
		
	<!--- testing save new user --->
		
		<cfset l.submitsto = response.getESMSubmitsTo()>
		
		<cfset variables.httpObj.setPath(l.submitsto)>
		
		<cfset variables.httpObj.clear('formfield,urlfields')>
		
		<cfset l.fields = structnew()>
		
		<cfloop list="#l.formfields#" index="l.idx">
			<cfset l.fields[l.idx] = createuuid()>
		</cfloop>
		
		<cfset l.fields['country'] = 'USA'>
		<cfset l.fields['id'] = ''>
		
		<cfset l.fields['line1'] = 'myline1'>
		<cfset l.fields['postalcode'] = '58000'>
		<cfset l.fields['state'] = "CO">
		<cfset l.fields['active'] = 1>
		
		<cfset l.fieldsBackup = duplicate(l.fields)>
		
		<cfloop collection="#l.fields#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fields[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new user")>
		
		<cfset asserttrue(condition=(response.existsByPattern("""FIELD"":""password""")),message="validation did not find password error")>
		<cfset asserttrue(condition=(response.existsByPattern("valid email")),message="validation did not find valid email error")>

		<cfset l.pwd = "gazook#randrange(340,1000)#@lklklk#randrange(340,1000)#.com">
		<cfset variables.httpObj.addFormField('opi_un_poip', l.pwd)>
		<cfset variables.httpObj.addFormField('hjl_pwd_kjljk', left(l.fields['hjl_pwd_kjljk'],10) )>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while saving new user")>
		
		<cfset assertfalse(condition=(response.existsByPattern("""validation")),message="validation did not find password error")>
		
	<!--- test edit user form--->
		
		<cfset l.id = response.getByPattern('[a-zA-Z0-9\-]{35}')>
		
		<cfset variables.httpObj.setPath("/users/editUser/")>

		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while getting edit user form")>

	<!--- test save existing user --->
		<!--- compare fieldsback query to input query, remove uncomparable elements --->
		<cfset l.fieldsOut = response.getESMFormStruct()>
		
		<cfloop list="hjl_pwd_kjljk,activeold,id,opi_un_poip" index="l.ldelidx">
			<cfset structdelete(l.fields, l.ldelidx)>
			<cfset structdelete(l.fieldsOut, l.ldelidx)>
		</cfloop>

		<cfset assertEquals(expected = l.fieldsOut, actual = l.fields, message="WHen saving user, query in is not query out")>
		
		<cfset variables.httpObj.clear('formfields,urlfields')>
		

		<cfloop collection="#l.fieldsBackup#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fieldsBackup[l.idx])>
		</cfloop>
		
		<cfset variables.httpObj.setPath("/users/saveUser/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while updating user")>
		
	<!--- test deleting user --->
		
		<!--- clear form leave url which already contains id --->
		<cfset variables.httpObj.clear('formfields')>
		
		<cfset variables.httpObj.setPath("/users/deleteUser/")>
		<cfset variables.httpObj.addUrlField('id', l.id)>
		
		<cfset response = variables.httpObj.load()>

		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while deleting user")>
		
		<!--- reload users start page and confirm id not there --->
		<cfset variables.httpObj.clear('formfields,urlfields')>
		
		<cfset variables.httpObj.setPath("/users/startPage/")>
		
		<cfset response = variables.httpObj.load()>
		
		<cfset l.findid = response.getByPattern(replace(l.id, "-", "\-","all"))>
		
		<cfset asserttrue(condition=(l.findid EQ ""),message="user was not deleted")>
	</cffunction>
    
</cfcomponent>