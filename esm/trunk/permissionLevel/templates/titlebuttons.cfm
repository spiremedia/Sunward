<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.str = "">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("permissionlevel","add Permission Level")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("permissionlevel","Edit Permission Level"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>

<cfif securityObj.isallowed("permissionlevel","delete Permission Level")>
	<cfset lcl.id = getdataitem('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(getdataitem('id') EQ 0,DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''/permissionLevel/DeletePermissionLevel/?id='' + document.myForm.id.value)">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>