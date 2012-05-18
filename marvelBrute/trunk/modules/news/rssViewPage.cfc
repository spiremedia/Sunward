<cfcomponent name="news View" extends="resources.page">
   
	<cffunction name="postObjectLoad">
		<!--- mainContent --->
		<cfset data = structnew()>
		<cfset data.view = 'rss'>
		<cfset addObjectByModulePath('onecontent', 'news', data)>
	</cffunction>
</cfcomponent>