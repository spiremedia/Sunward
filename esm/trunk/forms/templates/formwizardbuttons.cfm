<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.str = ''>

<cfif lcl.info.id neq 0 and lcl.userobj.isallowed("forms","Edit Form")>
	<cfset lcl.str = lcl.str & '<input type="submit" id="savebutton" value="Save">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.addformitem('definition', 'definition', true, 'hidden', '')>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
