<cfset lcl.gallerygroupmodel = getDataItem('gallerygroupmodel')>
<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.gallerygroupmodel.getGalleryGroups()>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Group">
<cfset lcl.form.addformitem('gallerygroupid', 'Choose a Group', false, 'select', lcl.widgetinfo.gallerygroupid, lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = "lightboxgrid,sidescroll,galleria,sunwardgallery">
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Mode">
<cfset lcl.form.addformitem('displaymode', 'Choose a Mode', false, 'select', lcl.widgetinfo.displaymode, lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetModel.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 310);
</script>
