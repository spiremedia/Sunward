<cfset lcl.page = getDataItem('page')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.info = lcl.page.getPageInfo()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:300px;heigth;250px">
<cfset lcl.form.addformitem('description', 'Description', false, 'textarea', lcl.info.description, lcl.options)>
<cfset lcl.options.style="width:300px;heigth;250px">
<cfset lcl.form.addformitem('keywords', 'Keywords', false, 'textarea', lcl.info.keywords, lcl.options)>
<cfset lcl.options.style="width:300px;heigth;250px">
<cfset lcl.form.addformitem('summary', 'Search Results Description', false, 'textarea', lcl.info.summary, lcl.options)>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>