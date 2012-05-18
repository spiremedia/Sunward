<cfcomponent name="formcontentpage" extends="resources.page">

	<cffunction name="preObjectLoad">
	
		<cfset data = structNew()>
		<cfset data.formid = "">
		
		<cfif isDefined("url.formid")>
			<cfset data.formid = url.formid>
		</cfif>
		
		<cfset formcontentObj = createObject('component', 'modules.forms.controller').init(
			data = data,
			requestObject = requestObject
		)>
		<cfset formcontentObj.showFormContentHTML()>
		<cfabort>
		
	</cffunction>
	
</cfcomponent>