<cfif variables.isDataItemSet('searchinfo')>
	<cfset lcl.usersearch = getDataItem('searchinfo')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
	<cfset lcl.tbl.addColumn('Username','username', 'alpha','<a href="/users/edituser/?id=[id]">[username]</a>')>
	<cfset lcl.tbl.addColumn('First Name','fname', 'alpha')>
	<cfset lcl.tbl.addColumn('Last Name','lname', 'alpha')>
	<cfset lcl.tbl.addColumn('Modified','modified', 'date')>
	<cfset lcl.tbl.setQuery(lcl.usersearch)>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
</cfif>