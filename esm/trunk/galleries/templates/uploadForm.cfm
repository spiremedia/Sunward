<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('imageid', 'imageid', false, 'hidden', requestObj.getFormUrlVar("id"))>
<cfset lcl.form.addformitem('imagefile', 'Image to Upload', false, 'file', "")>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		document.getElementById('deleteBtn').style.display="inline";
		document.myForm.id.value = id;	
	}
	
</script>
</form>