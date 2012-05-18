<cfif variables.securityObj.isallowed('help','Edit Help Item')>
	<cfoutput>
		<input type="button" onClick="location.href='/Help/EditHelpItem/?m=#requestObj.getFormUrlVar('m')#';" value="Edit">
	</cfoutput>
</cfif>