<cfset lcl.search = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Member Name','name', 'alpha','<a href="../editMember/?id=[id]">[name]</a>')>
<cfset lcl.tbl.addColumn('Username','username', 'alpha')>
<cfset lcl.tbl.addColumn('Email','email', 'alpha')>
<cfset lcl.tbl.addColumn('Changed Date','modified', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.search)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
