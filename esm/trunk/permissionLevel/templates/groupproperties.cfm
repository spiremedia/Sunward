<cfset lcl.securityItems = getDataItem('securityItems')>
<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('Description', 'Description', false, 'textarea', lcl.info.item.description)>
<cfloop from="1" to="#arraylen(lcl.securityitems)#" index="sitm">
	<cfif len(lcl.securityitems[sitm].securityitems)>
		<cfif structkeyexists(lcl.info.itemstruct,lcl.securityitems[sitm].name)>
			<cfset lcl.selected = lcl.info.itemstruct[lcl.securityitems[sitm].name].items>
		<cfelse>
			<cfset lcl.selected = "">
		</cfif>
	
		<cfset lcl.options.options = "View," & rereplace(lcl.securityitems[sitm].securityitems,"[^,a-zA-Z]","_","all")>
		
		<cfset lcl.form.addformitem('#lcl.securityitems[sitm].name#_items', 
											lcl.securityitems[sitm].label, 
											false, 
											'checkbox', 
											lcl.selected, 
											lcl.options)>
	</cfif>
</cfloop>

<cfset lcl.form.endform()>
<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
	
</script>
<cfoutput>#lcl.form.showHTML()#</cfoutput>