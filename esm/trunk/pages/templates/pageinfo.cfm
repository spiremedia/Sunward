<cfset lcl.page = getDataItem('page')>
<cfset lcl.info = lcl.page.getPageInfo()>
<cfoutput>
<cfif lcl.info.id NEQ "">
	This published page url path is:  
	<p style="margin-left:20px;" id="pageurlpath"><a href="#variables.securityObj.getCurrentSiteUrl()##lcl.page.getPath()#" target="_blank">#variables.securityObj.getCurrentSiteUrl()##lcl.page.getPath()#</a></p>
</cfif>

Crosslink from other esm sites by using the following link in the HTML Content link editor in the "Link Url" field:
<p style="margin-left:20px;">{{link[#securityobj.getCurrentSiteId()#][#lcl.info.id#]}}</p>
</cfoutput>