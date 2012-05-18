<cfset lcl.info = getDataItem('info')>
<input type="submit" value="Save">
<input type="button" onclick="self.close()" value="Cancel">
<cfoutput>
<input type="hidden" name="m" value="#lcl.info.getVar('module')#">
</cfoutput>
