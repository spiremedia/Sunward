<cfset lcl.pageOwners = getDataItem('pageOwners')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.pageOwners>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>

<cfset lcl.form.addformitem('reviewerId', 'Reviewer', true, 'select', lcl.pageowners.id[1] ,lcl.options)>
<cfset lcl.options = structnew()>

<cfset lcl.options.style = "width:350px;height:70px;">

<cfset lcl.form.addformitem('Comments', 'Comments', true, 'textarea', '', lcl.options)>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>