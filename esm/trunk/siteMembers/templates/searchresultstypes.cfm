<cfset lcl.search = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Member Type Name','name', 'alpha','<a href="../editMemberType/?id=[id]">[name]</a>')>
<cfset lcl.tbl.addColumn('Changed Date','modified', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.search)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
