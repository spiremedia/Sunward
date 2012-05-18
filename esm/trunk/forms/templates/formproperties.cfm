<cfset lcl.info = getDataItem('Info')>
<cfset lcl.users = getDataItem('availableUsers')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options.list = "'#valuelist(lcl.users.username,"','")#'">
<cfset lcl.form.addformitem('recipient', 'Email Recipient: ', true, 'autocomplete', lcl.info.recipient, lcl.options)>
<cfset lcl.form.addformitem('reply', 'Form Submission Reply: ', true, 'textarea', lcl.info.reply)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchandsubmit(){
		document.myForm.action = '/Forms/saveForm/?really=1';
		document.myForm.enctype="multipart/form-data";
		document.myForm.submit();	
	}
</script>





