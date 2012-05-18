<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('oldpassword', 'Old Password', true, 'password', "")>

<cfset lcl.form.addformitem('newpassword', 'New Password', true, 'password', "")>
<cfset lcl.form.addformitem('newpasswordrpt', 'New Password Repeat', true, 'password', "")>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>