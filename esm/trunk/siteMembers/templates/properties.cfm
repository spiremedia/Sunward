<cfset lcl.info = getDataItem('Info')>
<cfset lcl.memberTypes = getDataItem('memberTypes')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('name', 'Name', true, 'text', lcl.info.name)>
<cfset lcl.form.addformitem('email', 'Email', true, 'text', lcl.info.email)>
<cfset lcl.form.addformitem('password', 'Password', true, 'password')>

<cfset lcl.form.addformitem('memberType', '', false, 'hidden', lcl.info.memberTypes)>
<cfset lcl.config = structnew()>	
<cfset lcl.config.options = lcl.memberTypes>
<cfset lcl.config.valueskey = 'id'>
<cfset lcl.config.labelskey = 'name'>
<cfset lcl.config.addblank = true>
<cfset lcl.config.blanktext = "">
<cfset lcl.form.addformitem('memberTypes', 'Member Types', false, 'listmanager', lcl.info.memberTypes, lcl.config)>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
</script>