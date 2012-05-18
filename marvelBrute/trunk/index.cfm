<cfparam name="url.path" default="/">
<cfset localrequest = application.settings.makeRequestObject()>

<cf_toplevelcache 	urlidentifyer="#localrequest.getUrlIdentifyer()#" 
					postProcess="#application.site.getPostProcesses()#"
                    requestObject = "#localrequest#"
					duration="20">

	<cfset page = application.site.getPage(localrequest)>
	<cfset page.preObjectLoad()>
	<cfset page.loadObjects(application.views, application.modules)>
	<cfset page.postObjectLoad()>
	<cfset cachelength = page.getCacheLength()>
	<cfset is404 = page.is404()>
	<cfset page.showPage()>
</cf_toplevelcache>