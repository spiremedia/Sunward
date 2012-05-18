<cfset lcl.info = getDataItem('info')>


<cfset lcl.str = "">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("contentGroups","add Content Group")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("contentGroups","Edit Content Group"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>
	
<cfif securityObj.isallowed("contentGroups","delete Content Group")>
	<cfset lcl.id = getdataitem('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" value="Delete" #iif(getdataitem('id') EQ 0,DE('style="display:none;"'),DE(''))# onClick="verify(''Are you sure you wish to delete this group?'',''/contentGroups/deleteContentGroup/?id='' + document.myForm.id.value)">'>
</cfif>

<cfoutput>#lcl.str#</cfoutput>

