<script>
	function sendPublish(id){
		ajaxWResponseJsCaller('/pages/publishPage/', 'id=' + id );
	}
	
	function update(){
		relocate('/pages/draftPages/');	
	}
</script>
<cfset lcl.dp = getDataItem('draftpages')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
<cfset lcl.tbl.addColumn('PageName','username', 'alpha','<a href="/Pages/EditPage/?id=[id]">[pagename]</a>')>
<cfset lcl.tbl.addColumn('Site Map Location','urlpath', 'alpha')>
<cfset lcl.tbl.addColumn('Summary','summary', 'alpha')>
<cfset lcl.tbl.addColumn('Created By','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Modified','modifieddate', 'date')>
<!--->
<cfset lcl.tbl.addColumn('Actions','custom', 'alpha','<a href="/Pages/EditPage/?id=[id]">Edit</a> <a  href="javascript:void" onClick="sendPublish(''[id]'')">Publish</a> <a href="/Pages/DeletePage/?id=[id]">Delete</a>')>
--->
<cfset lcl.tbl.addColumn('Actions','custom', 'alpha','<a href="/Pages/EditPage/?id=[id]">Edit</a>')>
<cfset lcl.tbl.setQuery(lcl.dp)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
