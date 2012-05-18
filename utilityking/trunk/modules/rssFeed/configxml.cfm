<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^rssFeed">
		<loadcfc>rss</loadcfc>
		<title>Rss Feeds from Sherman and Howard LLC</title>
		<description>Sherman and Howard is a lawfirm.</description>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>