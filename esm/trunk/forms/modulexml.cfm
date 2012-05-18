<cfsavecontent variable="modulexml">
<module name="Forms" label="Forms" menuOrder="14" securityitems="Add Form,Edit Form,Delete Form,Form Data">

	<action name="Add Form" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveForm">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="formproperties.cfm"/>
	</action>

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>
	
	<action name="Delete Client Module"/>
	<action name="InPlaceEditorCallback"/>
	
	<action name="Delete Form" isSecurityItem="1"/>
	
	<action name="Download Form Data" isSecurityItem="1"/>

	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>

	<action name="Edit Form" isform="1" template="twocolumnwnavigation" formsubmit="saveForm">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="formproperties.cfm"/>
		<template name="mainContent" title="Form Content" file="formiframe.cfm"/>
		<template name="mainContent" title="Form History" file="history.cfm"/>
	</action>

	<action name="Edit Form Wizard" isform="1" template="popup-twocolFORMS" formsubmit="saveFormWizard">
		<template name="browseContent" title="Fields Palette" file="fieldpalette.cfm"/>
		<template name="title" title="Form Content" file="formwizardtitle.cfm"/>
		<template name="title" title="buttons" file="formwizardbuttons.cfm"/>
		<template name="mainContent" title="Content" file="formwizardcontent.cfm"/>
	</action>

	<action name="Form Data" onMenu="2" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="formdatatitlelabel.cfm"/>
		<template name="mainContent" title="" file="formdata.cfm"/>
	</action>
	
	<action name="Save Client Module"/>

	<action name="Save Form"/>
	
	<action name="Save Form Wizard"/>

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Start Page" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>

	<action name="Search" method="search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>




