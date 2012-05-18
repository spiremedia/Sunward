<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^sitemapxml">
		<loadcfc>siteMap</loadcfc>
        <template>_blank</template>
		<show>sitemap</show>
	</action>
	<action match="^robotstxt">
		<loadcfc>siteMap</loadcfc>
        <template>_blank</template>
		<show>robotsfile</show>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>