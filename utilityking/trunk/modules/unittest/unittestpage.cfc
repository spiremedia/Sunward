<cfcomponent name="sitemappage" extends="resources.page">
	
	<cffunction name="postObjectLoad">
		<!--- pray pray pray! --->
        
		<cfset var module = listgetat(requestObject.getFormUrlVar('path'),2,"/")>
        <cfset var lcl = structnew()>
        <cfset var suite = CreateObject("component", "mxunit.framework.TestSuite").TestSuite()>
        <cfset var dir = "">

	<cfif NOT(requestObject.isVarSet('debug') AND requestObject.getVar('debug') EQ 1)>
		<cfabort>
	</cfif>	

        <cfparam name="url.output" default="html">
        <cfset request.requestObject = requestObject>

        <cfdirectory action="list" name="lcl.moduledirs" directory="#requestObject.getVar("machineroot") & "/modules/"#">


        <cfloop query="lcl.moduledirs">
			<cfif type EQ "dir" AND (module EQ "all" OR name EQ module)>
				<cfset dir = requestObject.getVar("machineroot") & "/modules/" & name>

                <cfdirectory action="list" name="lcl.teststorun" directory="#dir#" filter="*test.cfc">

                <cfloop query="lcl.teststorun">
                    <cfset suite.addAll("modules." 
								& lcl.moduledirs.name 
								& "." 
								& replace(lcl.teststorun.name[lcl.teststorun.currentrow], ".cfc", ""))>
                </cfloop>
			</cfif>
        </cfloop>
        
        <cfset results = suite.run()>
        
        <cfif listfind("query", url.output)>
        	<cfdump var=#results.getResultsOutput(url.output)#><cfabort>
        </cfif>
        
        <cfoutput>#results.getResultsOutput(url.output)#</cfoutput>
        
		<cfabort>
	</cffunction>
    
	
	
    <cffunction name="getCacheLength">
    	<cfreturn 0>
    </cffunction>

</cfcomponent>