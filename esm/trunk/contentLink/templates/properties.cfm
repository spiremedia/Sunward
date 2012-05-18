<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.assetList = getDataItem('grouptypes')>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetList>
<cfset lcl.options.valueskey = 'assetGroup'>
<cfset lcl.options.labelskey = 'assetGroup'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = 'Use Existing'>
<cfset lcl.form.addformitem('newassetsgroup', 'Asset Group (existing)', true, 'select','',lcl.options)>

<cfset lcl.form.addformitem('existingassetsgroup', 'Asset Group (new)', true, 'text',  lcl.info.getfield('assetgroup'))>
<cfset lcl.form.addformitem('filename', 'File', true, 'file', '')>
<!--->
<cfset lcl.form.addformitem('previewfilename', 'Preview File', true, 'file', '')>
--->
<cfset lcl.form.addformitem('startdate', 'Show Date', false, 'date', lcl.info.getfield('startdate'))>
<cfset lcl.form.addformitem('enddate', 'Hide Date', false, 'date', lcl.info.getfield('enddate'))>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchandsubmit(){
		document.myForm.action = '/Assets/saveAsset/?really=1';
		document.myForm.enctype="multipart/form-data";
		document.myForm.submit();	
	}
</script>





