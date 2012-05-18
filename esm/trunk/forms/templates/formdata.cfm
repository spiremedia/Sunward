
<cfset lcl.formsearch = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
<cfset lcl.tbl.addColumn('Form Name','name', 'alpha')>
<!--- <cfset lcl.tbl.addColumn('Created','created', 'datetime')> --->
<cfset lcl.tbl.addColumn('Submits: From - To', 'submissiondate', 'alpha')>
<cfset lcl.tbl.addColumn('XLS', 'modified', 'datetime','<a href="/forms/downloadFormData/?id=[formid]&format=xls"><img src="/ui/images/button/download-text.gif" border="0" alt="Download XLS" /></a>')>
<cfset lcl.tbl.addColumn('XML', 'modified', 'datetime','<a href="/forms/downloadFormData/?id=[formid]&format=xml"><img src="/ui/images/button/download-text.gif" border="0" alt="Download XML" /></a>')>
<cfset lcl.tbl.setQuery(lcl.formsearch)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>