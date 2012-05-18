<cfset lcl.info = getDataItem('info')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:600px;height:405px;">
<cfset lcl.form.addformitem('html', 'Content', false, 'tiny-mce', lcl.info.getVar('contents'), lcl.options)>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	window.resizeTo(900,800);
</script>