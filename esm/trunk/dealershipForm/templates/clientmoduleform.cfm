<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>
<cfset lcl.users = getDataItem('availableUsers')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options.list = "'#valuelist(lcl.users.username,"','")#'">
<cfset lcl.form.addformitem('recipient_dealership', 'Email Recipient for Dealership Inquiries: ', true, 'autocomplete', lcl.widgetinfo.recipient_dealership, lcl.options)>
<cfset lcl.form.addformitem('reply', 'Form Submission Reply: ', true, 'textarea', lcl.widgetinfo.reply)>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetModel.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 375);
</script>