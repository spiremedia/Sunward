<cfset lcl.info = getDataItem('info')>
<cfif lcl.info.getVar('new') EQ 1>
	There are currently no Help documents for this section.
	<cfif variables.securityObj.isallowed('help','Edit Help Item')>
		<cfoutput>
			<a href="/Help/EditHelpItem/?&m=#requestObj.getFormUrlVar('m')#">Add Documentation</a>.
		</cfoutput>
	</cfif>
	<script>
		window.resizeTo(900,370);
	</script>
<cfelse>
	<cfoutput>
		<style>
			h1 {font-family:verdana;
				font-size:12px;
				color:black;
			}
			dl##maincontent {

			}
			ul {
				margin:3px;
			}
			li {
				margin:3px;
			}
		</style>
		#lcl.info.getVar('contents')#
		<br style="clear:both;"/>
	</cfoutput>
	<script>
		window.resizeTo(900,800);
	</script>
</cfif>
	
