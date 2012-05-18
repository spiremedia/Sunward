<cfcomponent name="news View" extends="resources.page">
	<cffunction name="preobjectLoad">
		<cfset variables.newsid = variables.requestObject.getFormUrlVar('path')>
		<cfset variables.newsid = listlast(variables.newsid, "/")>

		<cfset variables.news = createObject('component','modules.news.models.news').init(requestObject)>
		<cfset variables.newsInfo = variables.news.getNews(variables.newsid)>
		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|News~NULL~/News/|#variables.newsInfo.title#|">
		<cfset variables.pageInfo.title = variables.newsInfo.title>
	</cffunction>
    
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		<!--- main title --->
		<cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('mainTitle', 'simpleContent', data)>

		<!--- mainContent --->
		<cfset data = structnew()>
		<cfset data.view = 'item'>
		<cfset data.newsInfo = variables.NewsInfo>
		<cfset addObjectByModulePath('middleContentItem2', 'news', data)>
	</cffunction>
</cfcomponent>