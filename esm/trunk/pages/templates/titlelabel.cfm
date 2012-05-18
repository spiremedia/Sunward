<cfset lcl.page = getDataItem('page')>
<cfset lcl.form = createWidget("formcreator").init()>
<cfset lcl.info.pageinfo = lcl.page.getPageInfo()>

<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('pagename', 'Page Name', true, 'text', lcl.info.pageinfo.pagename)>
<cfset lcl.form.addformitem('pagenameold', '', false, 'hidden', lcl.info.pageinfo.pagename)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>