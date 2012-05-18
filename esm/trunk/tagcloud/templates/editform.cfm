<cfset lcl.info = getDataItem('Info')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.info.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
The tag cloud has been saved to the content area selected.  To remove it use the delete button above.<br/>
<input type="button" onclick="reloadbase();self.close()" value="Close">



<script>
	window.resizeTo(870, 287);
</script>