<cfset lcl.searches = getDataItem('monthssearches')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
<cfset lcl.tbl.addColumn('Date','datetime', 'datetime')>
<cfset lcl.tbl.addColumn('Criteria','criteria', 'alpha')>
<cfset lcl.tbl.addColumn('Records Found','recordsfound', 'alpha')>

<cfset lcl.tbl.setQuery(lcl.searches)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
