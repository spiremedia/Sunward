<cfsavecontent variable="modulexml">
<module name="SEO" label="SEO" menuOrder="20" topnav="false" securityitems="Analyize Page">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
	</action>
	
	<action name="Edit Key Phrases" method="keyphrases" label="Edit Key Phrases" isSecurityItem="1" onmenu="1" template="twocolumnwnavigation" formsubmit="keyphrasessave">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="keyphraseslabel.cfm"/>
        <template name="title" title="btn" file="keyphrasesbutton.cfm"/>
		<template name="mainContent" title="Data" file="keyphrasesform.cfm"/>
   	</action>
    
    <action name="Site Search View By Month" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="sitesearchbrowse.cfm"/>
		<template name="browseContent" title="Search" file="sitesearchsearch.cfm"/>
		<template name="title" title="label" file="sitesearchtitlelabel.cfm"/>
		<template name="mainContent" title="" file="sitesearchbymonth.cfm"/>
	</action>
    
    <action name="lcl Searches" method="sitesearchstart" onmenu="1" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="sitesearchbrowse.cfm"/>
		<template name="browseContent" title="Search" file="sitesearchsearch.cfm"/>
		<template name="title" title="label" file="sitesearchtitlelabel.cfm"/>
		<template name="mainContent" title="" file="sitesearchstart.cfm"/>
	</action>

	<action name="SiteSearchsearch" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="sitesearchbrowse.cfm"/>
		<template name="browseContent" title="Search" file="sitesearchsearch.cfm"/>
		<template name="title" title="label" file="sitesearchtitlelabel.cfm"/>
		<template name="mainContent" title="" file="sitesearchSearchResults.cfm"/>
	</action>
    
    <action name="keyphrasessave"/>
</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>
