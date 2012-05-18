<cfcomponent name="varlogger">
<!--- 
<cfset createObject('component','utilities.varlogger').init(
	name="name",
	requestObject = requestObject,
	data = data
)>
 --->
	<cffunction name="init">
    	<cfargument name="name" required="yes">
        <cfargument name="requestObject" required="yes">
        <cfargument name="data" required="true">
        <cfargument name="extension" default=".html">
        <cfargument name="folder" default="/tmp/">
    	
        <cfset var systemfolder = requestObject.getVar('machineroot') & folder>
		<cfset var filename = "#name##dateformat(now(),"yyyymmdd")##timeformat(now(),"hhmmss")##extension#">

		<cfif not directoryexists(systemfolder)>
        	<cfthrow message="directory #folder# does not exists for varlogger.">
        </cfif>
		
		<cfif NOT issimplevalue(data)>
        	<cfsavecontent variable="data">
            	<cfdump var=#data#>
            </cfsavecontent>
        </cfif>
        
        <cffile action="write" file="#systemfolder##filename#" output="#data#">
    </cffunction>
</cfcomponent>