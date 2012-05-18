<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "">

<cfif securityObj.isallowed("galleries","add gallery group") or securityOBj.isallowed("galleries","Update gallery Group")>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>
	
<cfif securityObj.isallowed("galleries","Delete Gallery Group")>
	<cfset lcl.id = getdataitem('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(lcl.info.id EQ 0,DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''../deleteGalleryGroup/?id='' + document.myForm.id.value)">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>

