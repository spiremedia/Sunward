<cfset lcl.memberTypes = getDataItem('memberTypes')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.page = getDataItem('page')>
<cfset lcl.info = lcl.page.getPageInfo()>

<cfset lcl.form.startform()>

<cfif lcl.membertypes.recordcount>

	If Member Types are selected, only associated users will be able to browse this page.  
	
	<cfset lcl.form.addformitem('memberType', '', false, 'hidden', lcl.info.memberTypes)>
	
	<cfset lcl.config = structnew()>
	
	<cfset lcl.config.options = lcl.memberTypes>
	<cfset lcl.config.valueskey = 'id'>
	<cfset lcl.config.labelskey = 'name'>
	<cfset lcl.config.addblank = true>
	<cfset lcl.config.blanktext = "No Restriction">
	<cfset lcl.form.addformitem('memberTypes', 'Restrictions', true, 'listmanager', lcl.info.memberTypes, lcl.config)>
<cfelse>
	Not Applicable.
	<cfset lcl.form.addformitem('memberTypes', '', true, 'hidden', "")>
</cfif>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>