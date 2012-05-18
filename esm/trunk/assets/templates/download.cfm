<cfset lcl.info = getDataItem('Info')>
<cfset lcl.link = getDataItem('link')>
<cfoutput>
	<a href="#lcl.link#" target="_blank">#lcl.info.getField('name')#</a>
</cfoutput>