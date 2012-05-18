<cfset lcl.info = getDataItem('widgetsmodel')>
<cfoutput>
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../DeleteClientModule/?id=#lcl.info.getid()#');">
</cfoutput>