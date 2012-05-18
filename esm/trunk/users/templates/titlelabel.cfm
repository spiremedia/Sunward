<cfset lcl.userinfo = getDataItem('userinfo')>
<cfset lcl.form = createWidget("formcreator").init()>
<cfset lcl.form.startForm()>
<cfset lcl.unextra = structnew()>
<cfset lcl.unextra.style = "width:200px">
<cfset lcl.form.addformitem('opi_un_poip', 'User Name', true, 'text', lcl.userinfo.username, lcl.unextra)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>