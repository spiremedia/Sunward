<cfset lcl.info = getDataItem('Info')>
<cfset lcl.availableUsers = getDataItem('availableUsers')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = lcl.availableusers>
<cfset lcl.config.labelskey = 'fullname'>
<cfset lcl.config.valueskey = 'id'>
<cfset lcl.form.addformitem('usersingroup', 'Add a User to this<br/>Content Group', false, 'listmanager', valuelist(lcl.info.users.userid), lcl.config)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>