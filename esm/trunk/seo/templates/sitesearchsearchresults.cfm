<cfif variables.isDataItemSet('searchresults')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
	<cfset lcl.tbl.addColumn('Date','datetime', 'datetime')>
	<cfset lcl.tbl.addColumn('criteria','Criteria', 'alpha')>
	<cfset lcl.tbl.addColumn('Records Found','recordsfound', 'alpha')>
	<!---><cfset lcl.tbl.addColumn('Modified','modified', 'date')>--->
	<cfset lcl.tbl.setQuery(getDataItem('searchresults'))>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
</cfif>