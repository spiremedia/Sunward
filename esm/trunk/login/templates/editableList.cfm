<cfset lcl.list = getDataItem('list')>

<cfoutput query="lcl.list">
<p>
<h4 style="display:inline;">#title#</h4>
<span>#dateformat(itemdate, "mm/dd/yyyy")# #fullname# <cfif not active>(inactive)</cfif></span>
<p>#html#</p>
<cfif securityObj.isallowed('login','Edit Announcement')>
	<a href="../EditAnnouncement/?id=#id#">Edit</a>
</cfif>
</p>

</cfoutput>

<cfif lcl.list.recordcount EQ 0>
	<p>There are no announcements at this time.</p>
</cfif>
