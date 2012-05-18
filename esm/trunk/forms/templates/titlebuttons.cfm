<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.str = ''>
	

<cfif lcl.info.id neq "">
	<cfif lcl.userobj.isallowed("forms","Edit Form")>
		<cfset lcl.str = lcl.str & '<input type="submit" value="Save">'>
	</cfif>
	<cfif lcl.userobj.isallowed("forms","Delete Form")>
		<cfset lcl.str = lcl.str & ' <input type="button" value="Delete" onClick="verify(''Are you sure you wish to delete this Form?'',''../DeleteForm/?id=#lcl.info.id#'')">'>
	</cfif>	
    
<cfelseif lcl.userobj.isallowed("forms","Add Form")>
	<cfset lcl.str = lcl.str & '<input type="submit" value="Save">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>