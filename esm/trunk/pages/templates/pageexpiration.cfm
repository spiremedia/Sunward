<cfset lcl.page = getDataItem('page')>
<cfset lcl.info = lcl.page.getPageInfo()>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('showDate', 'Page Appears', false, 'date', lcl.info.showdate)>
<cfset lcl.form.addformitem('hideDate', 'Page Expires', false, 'date', lcl.info.hidedate)>

<cfset lcl.form.addformitem('showDateold', '', false, 'hidden', lcl.info.showdate)>
<cfset lcl.form.addformitem('hideDateold', '', false, 'hidden', lcl.info.hidedate)>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>