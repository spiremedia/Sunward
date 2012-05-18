<cfset lcl.info = getDataItem('Info')>

<cfset lcl.sitepages = getDataItem('SitePages')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>

<cfset lcl.form.addformitem('Description', 'Description', false, 'textarea', lcl.info.item.description)>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = lcl.sitepages>
<cfset lcl.config.valueskey = 'id'>
<cfset lcl.config.labelskey = 'pagename'>
<cfset lcl.form.addformitem('SitePages', 'Site Pages', false, 'listmanager', valuelist(lcl.info.pages.pageid), lcl.config)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
	
</script>
