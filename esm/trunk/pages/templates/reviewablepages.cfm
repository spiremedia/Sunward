
<cfset lcl.reviewables = getDataItem('reviewables')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Page Name','pagename', 'alpha','<a href="../editPage/?id=[id]">[pagename]</a>')>
<cfset lcl.tbl.addColumn('Site Map Location','urlpath', 'alpha')>
<cfset lcl.tbl.addColumn('Requested By','byname', 'alpha')>
<cfset lcl.tbl.addColumn('Request Date','datetime', 'date')>
<cfset lcl.tbl.setQuery(lcl.reviewables)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>