<cfset lcl.siteslist = getDataItem('siteslist')>

<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
<cfset lcl.tbl.addColumn('Site Name','name', 'alpha','<a href="/login/startPage/?switchsiteid=[id]">[name]</a>')>
<cfset lcl.tbl.addColumn('Site Url','url', 'alpha')>
<cfset lcl.tbl.setQuery(lcl.siteslist)>
<h2>Please choose a site to edit.</h2>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
