<cfset lcl.activity = getDataItem('recentActivity')>

<cfoutput query="lcl.activity">
	<p>#dateformat(actiondate, "mm/dd/yyyy")# #timeformat(actiondate,"hh:mm tt")# <b>#fullname#</b> #Description#</p>
</cfoutput>