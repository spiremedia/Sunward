
	<cfset lcl.formsearch = getDataItem('searchresults')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
	<cfset lcl.tbl.addColumn('Form Name','name', 'alpha','<a href="/forms/editForm/?id=[id]">[name]</a>')>
	<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
	<cfset lcl.tbl.addColumn('Changed Date','modified', 'datetime')>
	<cfset lcl.tbl.setQuery(lcl.formsearch)>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
