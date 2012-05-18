<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator").init()>

<cfset lcl.prop = structnew()>
<cfset lcl.prop.style="width:300px;">
<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('name', 'Asset Name', true, 'text', lcl.info.getfield('name'), lcl.prop)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>