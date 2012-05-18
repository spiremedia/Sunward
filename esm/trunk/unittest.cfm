<cfparam name="url.module" default="all">
<cfparam name="url.output" default="html">

<cfset request.requestObject = application.settings.makeRequestObject()>

<cfset suite = CreateObject("component", "mxunit.framework.TestSuite").TestSuite()>
<cfset dir = "">
<cfset lcl = structnew()>

<cfdirectory action="list" name="lcl.moduledirs" directory="#request.requestObject.getVar("machineroot") & "/"#">

<cfloop query="lcl.moduledirs">
	<cfif type EQ "dir" 
			AND (module EQ "all" OR name EQ module)
			AND name NEQ "mxunit">
		<cfset dir = request.requestObject.getVar("machineroot") & name>
		
		<cfdirectory action="list" name="lcl.teststorun" directory="#dir#" filter="*test.cfc">
		
		<cfloop query="lcl.teststorun">
			<cfset suite.addAll(
					lcl.moduledirs.name 
					& "." 
					& replace(lcl.teststorun.name[lcl.teststorun.currentrow], ".cfc", ""))>
		</cfloop>
	</cfif>
</cfloop>

<cfset results = suite.run()>

<cfif listfind("query", url.output)>
	<cfdump var="#results.getResultsOutput(url.output)#"><cfabort>
</cfif>
<cfcontent reset="yes"><cfoutput>#results.getResultsOutput(url.output)#</cfoutput>