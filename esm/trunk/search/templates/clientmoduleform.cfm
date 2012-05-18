<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetModel.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
The content area has been saved as the "Search" results module.<br><br>
<input type="button"  value="Close" onClick="reloadbase()">

<script>
	window.resizeTo(900, 280);
</script>
