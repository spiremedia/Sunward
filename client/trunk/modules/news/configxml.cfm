<cfsavecontent variable="modulexml">
<moduleInfo searchable="0">
	<itempath>NewsAndEvents/News/View/</itempath>
	<action match="^NewsAndEvents/News/View/[A-Z0-9\-]{35}/?$">
		<loadcfc>newsView</loadcfc>
		<template>internal</template>
		<title>News</title>
		<pagename>News Item</pagename>
		<description>News</description>
		<keywords>news, happenings</keywords>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>