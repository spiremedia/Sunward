<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
	
    <cffunction name="regexonsitemap">
    	<cfset var lcl = structnew()>
     
     	<cfhttp method="get"  result="lcl.get" url="#request.requestObject.getVar("siteurl")#sitemapxml">

		<cfset asserttrue(left(lcl.get.statuscode,3) EQ 200)>
        <cfset asserttrue(isxml(lcl.get.filecontent))>
		<cfset asserttrue(condition = refindnocase("<urlset.*</urlset>",lcl.get.filecontent),
							message="did not find proper urlset xml")>

		<cfset asserttrue(condition = refindnocase("<url>.*</url>",lcl.get.filecontent),
							message="did not find proper url xml")>
    </cffunction>
    
</cfcomponent>