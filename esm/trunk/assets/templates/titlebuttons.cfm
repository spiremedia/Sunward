<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("assets","add asset"))
		OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("assets","Edit Asset"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>
	
<cfif  securityObj.isallowed("assets","delete asset") AND lcl.info.getfield('id') NEQ 0>
	<cfset lcl.str = lcl.str & ' <input type="button" value="Delete" onClick="verify(''Are you sure you wish to delete this Asset?'',''../DeleteAsset/?id=#lcl.info.getfield('id')#'')">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getfield('id'))>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>