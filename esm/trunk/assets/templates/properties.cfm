<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.assetList = getDataItem('grouptypes')> 

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetList>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.config.addblank = 1>
<cfset lcl.form.addformitem('assetgroupid', 'Asset Group', true, 'select',lcl.info.getfield('assetgroupid'),lcl.options)>

<cfset lcl.form.addformitem('startdate', 'Show Date', false, 'date', lcl.info.getfield('startdate'))>
<cfset lcl.form.addformitem('enddate', 'Hide Date', false, 'date', lcl.info.getfield('enddate'))>

<cfset lcl.options = structnew()>
<cfset lcl.options.style= 'width:300px;height:50px;'>
<cfset lcl.form.addformitem('description', 'Search Results<br>List Description', true, 'textarea', lcl.info.getfield('description'), lcl.options)>

<cfset lcl.form.addformitem('filename', 'File', true, 'file', '')>
<!---
<cfset lcl.form.addformitem('previewfilename', 'Preview File', true, 'file', '')>
--->

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchandsubmit(){
		document.myForm.action = '/Assets/saveAsset/?really=1';
		document.myForm.enctype="multipart/form-data";
		document.myForm.setAttribute('encoding',"multipart/form-data");
		document.myForm.submit();
	}
</script>








