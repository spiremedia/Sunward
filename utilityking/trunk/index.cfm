<cfparam name="url.path" default="/">
<cfset lclrequest = application.settings.makeRequestObject()>

<cf_toplevelcache 	urlidentifyer="#lclrequest.getUrlIdentifyer()#" 
					postProcess="#application.site.getPostProcesses()#"
                    requestObject = "#lclrequest#"
					duration="20">

	<cfset page = application.site.getPage(lclrequest)>
	<cfset page.preObjectLoad()>
	<cfset page.loadObjects(application.views, application.modules)>
	<cfset page.postObjectLoad()>
	<cfset cachelength = page.getCacheLength()>
	<cfset is404 = page.is404()>
	<cfset page.showPage()>
</cf_toplevelcache>