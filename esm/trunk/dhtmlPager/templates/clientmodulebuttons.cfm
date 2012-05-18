<cfset lcl.info = getDataItem('widgetsmodel')>
<cfoutput>

<input type="submit" value="Save">
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../DeleteClientModule/?id=#lcl.info.getid()#');">
<input type="button" onclick="self.close()" value="Cancel">
</cfoutput>