<cfset lcl.userinfo = getDataItem('userinfo')>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('users', 'Add User')) OR 
		(requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('users', 'Edit User'))>
	<input type="submit" value="Save">
</cfif>	
<cfif securityObj.isallowed('users', 'delete user')>
	<cfoutput>
    <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this user?','/users/deleteuser/?id=' + document.myForm.id.value)">
    </cfoutput>
</cfif>
