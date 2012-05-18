<cfset lcl.info = getDataItem('info')>
<cfoutput>
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../deleteItem/?id=#lcl.info.getid()#');">
</cfoutput>