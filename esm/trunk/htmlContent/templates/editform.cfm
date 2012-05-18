<cfset lcl.info = getDataItem('Info')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:600px;height:300px;">
<cfset lcl.form.addformitem('Content', 'Content', false, 'tiny-mce', lcl.info.getContent(), lcl.options)>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.info.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">


<script>
	window.resizeTo(870, 572);
</script>