<cfcomponent name="rssnewslistcontroller" output="false">
	
	<cffunction name="init" output="false">
		<cfargument name="data" required="true">
		<cfargument name="model" required="true">
		<cfargument name="requestObject" required="true">
        
		<cfset variables.id = listlast(requestObject.getFormUrlVar("path"), "/")>
		<cfset variables.data = arguments.data>
		<cfset variables.rssfeeditem = arguments.model.getFeedInfo(variables.id)>
        <cfset variables.rssfeedlist = arguments.model.getAvailableNewsItems(variables.id)>
		<cfset variables.requestObject = arguments.requestObject>

		<cfreturn this>
	</cffunction>
		
	<cffunction name="showHTML" output="false">
		<cfset var columnmap = structnew()>
        <cfset var meta = structnew()>
        <cfset var rss = "">
        <cfset var urlpathnodash = rereplace(requestObject.getVar("siteurl"), "\/$", "")>
		<cfoutput>
		<cfsavecontent variable="rss"><?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
<channel>
<title>#xmlformat(variables.rssfeeditem.title)#</title>
<link>#xmlformat("#requestObject.getVar("siteurl")#rss/#variables.rssfeeditem.id#/")#</link>
<description><![CDATA[ #variables.rssfeeditem.description# ]]></description>
<lastBuildDate></lastBuildDate>
<language>en-us</language>
<cfloop query="variables.rssfeedlist">
<cfset link = xmlformat("#urlpathnodash#/news/view/#variables.rssfeeditem.id#/")>
<item>
<title>#xmlformat(variables.rssfeedlist.title)#</title>
<link>#link#</link>
<pubDate>#dateformat(itemdate, "ddd, dd mmm yyyy")# #timeformat(itemdate, "HH:mm:ss")#</pubDate>
<description><![CDATA[ #variables.rssfeedlist.description# ]]></description>
<cfif isDefined("assetid") and assetid NEQ "">
	<guid isPermaLink="true">#urlpathnodash#{{asset[#assetid#]}}</guid>
	<enclosure url="#urlpathnodash#{{asset[#assetid#]}}" length="654654" type="audio/mpeg" />
<cfelse>
	<guid isPermaLink="true">#link#</guid>
</cfif>
</item>
</cfloop>
</channel>
</rss></cfsavecontent>
		</cfoutput>
       <!--- <!--- Map the orders column names to the feed query column names. --->

        <cfset columnMap.publisheddate = "CHANGEDDATE"> 
        <cfset columnMap.content = "DESCRIPTION"> 
        <cfset columnMap.title = "TITLE"> 
        <cfset columnMap.rsslink = "ID">
        
        <!--- Set the feed metadata. --->
        <cfset meta.title = variables.rssfeeditem.title>
        <cfset meta.link = requestObject.getVar("siteurl") & 'rss/#variables.rssfeeditem.id#/'>
        <cfset meta.description = variables.rssfeeditem.description> 
        <cfset meta.version = "rss_2.0">
        
        <!--- Create the feed. --->
        <cffeed action="create" 
            query="#variables.rssfeedlist#" 
            properties="#meta#"
            columnMap="#columnMap#" 
            xmlvar="rss">
--->
		<cfreturn rss>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.data#>
		<cfabort>
	</cffunction>
</cfcomponent>