<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "<input type=""hidden"" name=""id"" value=""#getdataitem('id')#"">">

<cfif (lcl.info.id EQ 0 AND securityObj.isallowed("assets","Add Asset Group"))
	 OR (lcl.info.id NEQ 0 AND securityOBj.isallowed("assets","Edit Asset Group"))>
	<cfset lcl.str = lcl.str & '<input type="submit" value="Save">'>
</cfif>
	
<cfif securityObj.isallowed("assets","delete Asset group")>
	<cfset lcl.id = getdataitem('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(lcl.info.id EQ 0,DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''../deleteAssetGroup/?id='' + document.myForm.id.value)">'>
</cfif>

<cfoutput>#lcl.str#</cfoutput>