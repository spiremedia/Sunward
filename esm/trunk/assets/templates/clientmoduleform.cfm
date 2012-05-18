<cfset lcl.assetsModel = getDataItem('assetsModel')>
<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetsmodel.getGroupTypes()>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Group">
<cfset lcl.form.addformitem('assetgroupid', 'Choose an Asset Group', false, 'select', lcl.widgetinfo.assetgroupid, lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetsmodel.getClientModuleAssets()>

<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose an Asset">
<cfset lcl.form.addformitem('assetids', 'Or individual assets', false, 'listmanager', lcl.widgetinfo.assetids, lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetModel.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 310);
</script>
