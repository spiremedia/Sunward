<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:400px;">
<cfset lcl.form.addformitem('title', 'Title', true, 'text', lcl.info.getfield('title'),lcl.options)>

<cfset lcl.form.addformitem('itemdate', 'Display Date?', true, 'date',  lcl.info.getfield('itemdate'), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:500px;height:200px;">
<cfset lcl.form.addformitem('html', 'Announcement', true, 'tiny-mce', lcl.info.getfield('html'), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = querynew('label,value')>
<cfset queryaddrow(lcl.options.options)>
<cfset querysetcell(lcl.options.options,'label','')>
<cfset querysetcell(lcl.options.options,'value','1')>

<cfset lcl.form.addformitem('active', 'Active?', false, 'checkbox',  lcl.info.getfield('active'), lcl.options)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>






