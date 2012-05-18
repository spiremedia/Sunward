<cfset lcl.info = getDataItem('Info')>
<cfset lcl.assetGroups = getDataItem('assetGroups')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = lcl.assetGroups>
<cfset lcl.config.labelskey = 'name'>
<cfset lcl.config.valueskey = 'id'>
<cfset lcl.form.addformitem('assetgroupsingroup', 'Add an Asset Group to<br/>this Content Group', false, 'listmanager', valuelist(lcl.info.assetgroups.id), lcl.config)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>