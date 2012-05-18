
	<cfset lcl.formsearch = getDataItem('searchresults')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
	<cfset lcl.tbl.addColumn('Page Name','pagename', 'alpha','<a href="/pages/EditPage/?id=[id]">[pagename]</a>')>
	<cfset lcl.tbl.addColumn('Title','title', 'alpha')>
	<cfset lcl.tbl.addColumn('URL Path','urlpath', 'alpha')>
	<cfset lcl.tbl.addColumn('Modified','modifieddate', 'date')> 
	<cfset lcl.tbl.setQuery(lcl.formsearch)>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>