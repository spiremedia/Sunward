<cfcomponent name="rssFeed" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfset var newsModel = createObject('component','modules.news.models.news').init(requestObject)>
		<cfset var eventsModel = createObject('component','modules.events.models.events').init(requestObject)>
		
		<cfset var newslist = "">
		<cfset var eventslist = "">

		<cfset newslist = newsmodel.getAvailableNewsItems()>
		<cfset eventslist = eventsmodel.getEventsList()>

		<cfquery name="variables.list" dbtype="query" >
			SELECT 
				'docs/news/' + filename as link, 
				'news' as type, 
				title, 
				itemdate as startdate,
				#now()# enddate,
				filesize more,
				description
			FROM newslist
			UNION ALL
			SELECT 
				'newsEvents/Events/Event/' + id + '/' as link, 
				'events' as type, 
				title,  
				startdate, 
				enddate,
				location as more,
				searchdescription
			FROM eventslist
			ORDER BY startdate DESC
		</cfquery>
		
		<cfset showRss()>
	</cffunction>
	
	<cffunction name="showRss" output="true">
		<cfset var siteurl = requestObject.getVar('siteurl')>
		<cfoutput>
		
		<cfcontent reset="true"><rss version="0.91">
		  <channel>
		    <title>#xmlformat(getField('title'))#</title>
		    <link>#xmlformat(siteurl)#</link>
		    <description>#xmlformat(getfield('description'))#</description>
		    <language>en-us</language>
		    <cfloop query="variables.list">
			    <item>
			      <title>#xmlformat(title)#</title>
			      <link>#xmlformat("#siteurl##link#")#</link>
			      <description>#xmlformat(description)#</description>
			    </item>
		    </cfloop>
		  </channel>
		</rss>
		</cfoutput>
		<cfabort>
	</cffunction>
</cfcomponent>