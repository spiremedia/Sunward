<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = '<input type="submit" value="Save">'>
	
<cfif isdataitemset('id') AND getdataitem('id') NEQ 0>
	<cfset lcl.id = getdataitem('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''/Security/DeleteSecurityGroup/?id=#lcl.id#'')">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>