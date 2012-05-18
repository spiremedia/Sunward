<cfset lcl.activity = getDataItem('recentActivity')>
<cfif lcl.activity.recordcount>
<cfoutput query="lcl.activity">
	<p>#dateformat(actiondate, "mm/dd/yyyy")# #timeformat(actiondate,"hh:mm tt")# <b>#fullname#</b> #Description#</p>
</cfoutput>
<cfelse>
<p>No records found.</p>
</cfif>