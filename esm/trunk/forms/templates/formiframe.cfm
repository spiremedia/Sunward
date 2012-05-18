<cfset lcl.info = getDataItem('info')>

<cfoutput>
	<iframe id="iframe" height="400" width="700" name="iframe" 
		src="#variables.securityObj.getCurrentSiteUrl()#showformcontent/?formid=#lcl.info.id#&preview=view"></iframe>
</cfoutput>