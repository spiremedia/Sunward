<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^system/reversionObjectView/">
		<loadcfc>reversion</loadcfc>
		<template>_blank</template>
		<title></title>		
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>