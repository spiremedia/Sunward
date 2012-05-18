<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>
<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('description', 'Description', false, 'textarea', lcl.info.description)>

<cfset lcl.form.endform()>

<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
</script>

<cfoutput>#lcl.form.showHTML()#</cfoutput>






