<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator").init()>
<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('username', 'Username', true, 'text', lcl.info.username)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>