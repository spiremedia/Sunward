<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.requestObj = getDataItem('requestObj')>

<cfset lcl.form.startform()>
<cfif lcl.requestObj.isformurlvarset('msg')>
	<cfoutput>#lcl.requestObj.getformurlvar('msg')#</cfoutput>
</cfif>
<cfset lcl.form.addcustomformitem('<b>Welcome, Please login:</b>')>
<cfset lcl.form.addformitem('username', 'Login', false, 'text', '')>
<cfset lcl.form.addformitem('password', 'Password', false, 'password', '')>
<cfset lcl.form.addcustomformitem('<input type="submit" value="Enter">')>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>