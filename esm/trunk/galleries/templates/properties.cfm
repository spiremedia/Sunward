<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.assetList = getDataItem('grouptypes')> 

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style= 'width:300px'>
<cfset lcl.form.addformitem('title', 'Title', true, 'text', lcl.info.getfield('title'), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style= 'width:300px;height:50px;'>
<cfset lcl.form.addformitem('description', 'Description', true, 'textarea', lcl.info.getfield('description'), lcl.options)>

<cfset lcl.form.addformitem('sortdate', 'Sort Date', true, 'date', lcl.info.getfield('sortdate'), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetList>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.config.addblank = 1>
<cfset lcl.form.addformitem('gallerygroupids', 'Associated Groups', true, 'listmanager',lcl.info.getfield('gallerygroupids'),lcl.options)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.getElementById('uploadBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
	
</script>








