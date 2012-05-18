<cfset lcl.page = getDataItem('page')>
<cfset lcl.users = getDataItem('availableUsers')>
<cfset lcl.pages = getDataItem('availablePages')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.info = lcl.page.getPageInfo()>

<cfset lcl.form.startform()>

<cfset lcl.config = structnew()>
<cfset lcl.config.size = 50>
<cfset lcl.form.addformitem('pageurl', 'Page URL', true, 'text', lcl.info.pageurl, lcl.config)>
<cfset lcl.form.addformitem('pageurlold', '', false, 'hidden', lcl.info.pageurl)>

<cfset lcl.config = structnew()>
<cfset lcl.config.size = 50>
<cfset lcl.form.addformitem('Title', 'Browser Title', true, 'text', lcl.info.title, lcl.config)>
<!--->
<cfset lcl.config = structnew()>
<cfset lcl.config.options = querynew('value,label')>
<cfset queryaddrow(lcl.config.options)>
<cfset querysetcell(lcl.config.options,'value',1)>
<cfset querysetcell(lcl.config.options,'Label',"Yes")>
<cfset lcl.form.addformitem('innav', 'In Navigation', false, 'checkbox', lcl.info.innav, lcl.config)>

--->

<cfset lcl.config = structnew()>
<cfloop query="lcl.pages">
	<cfset lcl.pages.urlpath[lcl.pages.currentrow] = "/" & lcl.pages.urlpath[lcl.pages.currentrow]>
</cfloop>

<cfset lcl.config.list = valuelist(lcl.pages.urlpath)>
<!--- <cfset lcl.config.valueskey = 'urlpath'>
<cfset lcl.config.labelskey = 'pagename'>
<cfset lcl.config.addblank = true>
<cfset lcl.config.blanktext = "No Relocation"> --->
<cfset lcl.form.addformitem('relocate', 'Redirect (start with /)', false, 'autocomplete', lcl.info.relocate, lcl.config)>

<!---
<cfset lcl.config = structnew()>
<cfset lcl.config.size = 50>
<cfset lcl.form.addformitem('redirect', 'Redirect', false, 'text', lcl.info.redirect, lcl.config)>
--->

<cfset lcl.config = structnew()>
<cfset lcl.config.options = getDataItem('views')>

<cfset lcl.form.addformitem('template', 'Template', true, 'select', lcl.info.template, lcl.config)>
<cfset lcl.form.addformitem('templateold', 'Template', true, 'hidden', lcl.info.template)>

<!---><cfif lcl.info.id EQ "">--->
	<cfset lcl.config = structnew()>
	<cfset lcl.config.options = lcl.pages>
	<cfset lcl.config.valueskey = 'id'>
	<cfset lcl.config.labelskey = 'pagename'>
	<cfset lcl.config.addblank = true>
	<cfset lcl.config.blanktext = "No Parent (use for home)">
	<cfset lcl.form.addformitem('parentid', 'Parent', true, 'select', lcl.info.parentid, lcl.config)>
	<cfset lcl.form.addformitem('parentidold', '', false, 'hidden', lcl.info.parentid)>
<!---><cfelse>
	<cfset lcl.form.addformitem('parentid', 'Parent', false, 'hidden', lcl.info.parentid)>
</cfif>--->

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','')>

<cfset lcl.form.addformitem('innavigation', 'Display in navigation', false, 'checkbox', lcl.info.innavigation, lcl.activeOptions)>
<cfset lcl.form.addformitem('innavigationold', '', false, 'hidden', lcl.info.innavigation)>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = lcl.users>
<cfset lcl.config.valueskey = 'id'>
<cfset lcl.config.labelskey = 'fullname'>
<cfset lcl.config.addblank = true>
<cfset lcl.config.blanktext = "Inherits">
<cfset lcl.form.addformitem('ownerid', 'Owner', true, 'select', lcl.info.ownerid, lcl.config)>


<cfset lcl.form.addformitem('searchindexable', 'Index By Site Search', false, 'checkbox', lcl.info.searchindexable, lcl.activeOptions)>

<!--- <cfset lcl.form.addformitem('login', 'Login', false, 'text', lcl.info.login)> --->

<cfif lcl.userobj.isallowed("pages","Manage Subsites")>
	<cfset lcl.activeOptions = structnew()>
	<cfset lcl.activeOptions.options = querynew('value,label')>
	<cfset queryaddrow(lcl.activeOptions.options)>
	<cfset querysetcell(lcl.activeOptions.options,'value','1')>
	<cfset querysetcell(lcl.activeOptions.options,'label','')>
	<cfset lcl.form.addformitem('subsite', 'Designate as Sub-Site<br>Landing Page', false, 'checkbox', lcl.info.subsite, lcl.activeOptions)>
<cfelse>
	<cfset lcl.form.addformitem('subsite', '', false, 'hidden', lcl.info.subsite)>
</cfif>

<cfset lcl.form.endform()>

<cfoutput>
	#lcl.form.showHTML()#
</cfoutput>