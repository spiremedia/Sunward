<cfsavecontent variable="modulexml">
<moduleInfo searchable="0">
	<itempath>newsAndEvents/Register/</itempath>
	<action match="^NewsAndEvents/Event/[A-Z0-9\-]{35}/?">
		<loadcfc>eventView</loadcfc>
		<template>internal</template>
		<title>Events &amp; Registration</title>
		<pagename>Events &amp; Registration</pagename>
		<description>Events</description>
		<keywords>events, happenings</keywords>
	</action>
	<action match="^NewsAndEvents/Register/[A-Z0-9\-]{35}/?">
		<loadcfc>eventView</loadcfc>
		<template>internal</template>
		<title>Events &amp; Registration</title>
		<pagename>Events &amp; Registration</pagename>
		<description>Events</description>
		<keywords>events, happenings</keywords>
		<onSuccess>NewsAndEvents/Thanks/</onSuccess>
	</action>
	<action match="^NewsAndEvents/Thanks/[A-Z0-9\-]{35}/?">
		<loadcfc>eventView</loadcfc>
		<template>internal</template>
		<title>Events Confirmation</title>
		<pagename>Events Confirmation</pagename>
		<description>Events</description>
		<keywords>events, happenings</keywords>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>