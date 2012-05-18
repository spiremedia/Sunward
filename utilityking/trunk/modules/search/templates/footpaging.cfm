<cfif variables.totalSearchRecords GT variables.rowcount>
	<cfoutput>
		#variables.renderPaging()#
    </cfoutput>
</cfif>