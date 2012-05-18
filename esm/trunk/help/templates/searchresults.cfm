<cfif variables.isDataItemSet('searchinfo')>
	<cfset lcl.usersearch = getDataItem('searchinfo')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
	<cfset lcl.tbl.addColumn('Event Name','name', 'alpha','<a href="../editEvent/?id=[id]">[name]</a>')>
	<cfset lcl.tbl.addColumn('Date','startdate', 'date')>
	<!---><cfset lcl.tbl.addColumn('Modified','modified', 'date')>--->
	<cfset lcl.tbl.setQuery(lcl.usersearch)>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
</cfif>