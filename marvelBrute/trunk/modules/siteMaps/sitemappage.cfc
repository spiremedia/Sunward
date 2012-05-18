<cfcomponent name="sitemappage" extends="resources.page">
	
	<cffunction name="postObjectLoad">
		<!--- Say CHEESE! --->
		<cfset var view = getField('show')>
		<cfset var sitemap = "">
        <cfset var data = "">
        <cfset var siteurl = variables.requestObject.getVar('siteurl')>
		
		<cfif view EQ 'sitemap'>
        	<cfset data = variables.getSiteMap().getSitePages()>
            
            <cfquery name="data" dbtype="query">
            	SELECT * FROM data WHERE searchindexable = 1
            </cfquery>
            
			<cfsavecontent variable="content"><?xml version="1.0" encoding="UTF-8"?>
				<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
				<cfoutput query="data">
				   <url>
					  <loc>#siteurl##displayurlpath#</loc>
					  <lastmod>#dateformat(modifieddate,'YYYY-MM-DD')#</lastmod>
				   </url>
				</cfoutput>
				</urlset> 
			</cfsavecontent>
		<cfelse>
			<cfset content = "Sitemap : #siteurl#sitemapxml">
		</cfif>
        
		<cfset addObjectByModulePath('onecontent', 'simplecontent', content)>

	</cffunction>
	
</cfcomponent>