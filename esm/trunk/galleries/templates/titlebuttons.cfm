<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("Galleries","Add Gallery Image"))
		OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("Galleries","Edit Gallery Image"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>
	
<cfif securityObj.isallowed("Galleries","Delete Gallery Image")>
	<cfset lcl.id = lcl.info.getField('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(lcl.id EQ 0,DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this image?'',''/Galleries/deleteGalleryImage/?id='' + document.myForm.id.value)">'>
	<cfset lcl.str = lcl.str & ' <input type="button" id="uploadBtn" #iif(lcl.id EQ 0,DE('style="display:none;'),DE(''))#" value="Upload Image" onClick="location.href=''/Galleries/uploadGalleryImage/?id='' + document.myForm.id.value">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getfield('id'))>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>