<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfoutput>
	<input type="submit" value="Save">
	<input type="button" value="Back To List" onClick="location.href='../StartPage/'">	
	<cfif securityObj.isallowed('login','Delete Announcement')>
		<input type="button" value="Delete" onClick="verify('Are you sure you wish to delete this Announcement?','../DeleteAnnouncment/?id=#lcl.info.getfield('id')#')">
	</cfif>
	<cfset lcl.form.startform()>
	<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getfield('id'))>
	<cfset lcl.form.endform()>
</cfoutput>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
