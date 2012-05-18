
<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options.style = "width:300px;">
<cfset lcl.form.addformitem('feedurl', 'Feed Url', false, 'text', lcl.widgetinfo.feedurl, lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = "Show Title,Show Description">
<cfset lcl.form.addformitem('DESCRIPTIONOPTIONS', 'Description Options', false, 'checkbox', lcl.widgetinfo.DESCRIPTIONOPTIONS, lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = "All,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20">
<cfset lcl.form.addformitem('rowcount', 'Show Records', false, 'select', lcl.widgetinfo.rowcount, lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = "None,All,40,75,130,200,300,400">
<cfset lcl.form.addformitem('rowmaxlen', 'Record Max Length', false, 'select', lcl.widgetinfo.rowmaxlen, lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetinfo.id)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="button" onclick="showfeed()" value="View">
<input type="submit" value="Save">

<div id="feedResult" style="height:200px;border:1px solid gray;width:700px;overflow:auto;margin:10px;">
</div>

<script>
	function showfeed(){
		var myForm = Form.serialize('myForm');
		var t = {ID : 'feedResult', URL : '/feedreader/testFeed/?' + myForm};
		ajaxupdater(t)
	}

	window.resizeTo(880, 580);
</script>
