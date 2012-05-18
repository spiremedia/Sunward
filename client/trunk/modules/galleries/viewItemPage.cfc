<cfcomponent name="updateCloud" extends="resources.page">
	<cffunction name="preObjectLoad">
    	<!--- 
		this file queries the sitemap for the description meta word and 
		then writes a file that gets consumed 
		by the controller for the cloud data
		--->
		<cfset var lcl = structnew()>
		<cfset var filename = requestObject.getVar("machineroot") & "/modules/tagCloud/clouddata.txt">
        <cfset var wordparser = createObject('component', 'utilities.wordparser').init(requestObject = variables.requestObject)>
        
        <cfquery name="lcl.pages" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description FROM publishedPages 
			WHERE siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published">
				AND expired = 0
                AND searchindexable = 1
		</cfquery>
        
        <cfset lcl.words = valuelist(lcl.pages.description, " ")>
       
		<cfset wordparser.loadString(lcl.words)>

		<cfset lcl.words = wordparser.getWords("array")>
		
		<cfset lcl.words = serializejson(lcl.words)>
        
        <cffile action="write" file="#filename#" output="#lcl.words#">	
        Wrote file	
		<cfabort>
	</cffunction>
</cfcomponent>