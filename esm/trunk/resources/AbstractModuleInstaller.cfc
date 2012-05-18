<cfcomponent name="abstractModuleInstaller">
	<cffunction name="init">
    	<cfargument name="settings" required="true">
        <cfset variables.settings = arguments.settings>
    	<cfset variables.notes = createobject('component', 'utilities.notetaker').init()>
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="install">
    	<cfargument name="modulename" required="true">
    	
		<cfset var dbobjects = "">
        <cfset var qry = "">
        <cfset var filecontents = "">
        <cfset var cleanfilename = "">
        
        <cfdirectory action="list" directory="#settings.getVar('machineroot') & trim(modulename) & '/install/dbobjects/'#" name="dbobjects" sort="alpha">
        
        <cfquery name="dbobjects" dbtype="query">
        	SELECT * 
            FROM dbobjects 
            WHERE type = 'File' 
            	AND (<cfloop list="idx,stp,sclrlf,trg,view,tbl,sql,tgr" index="ext">
                		name LIKE '%#ext#' <cfif ext NEQ 'tgr'> OR </cfif></cfloop>)
        </cfquery>
       
        <cfset notes.note('<b>Installing on module "#arguments.modulename#"</b>')>
        
        <cfloop query="dbobjects">
        	<cfset cleanfilename = right(dbobjects.name, len(dbobjects.name) - 4)>
        	<cffile action="read" file="#dbobjects.directory#/#dbobjects.name#" variable="filecontents">
        	<cftry>
                <cfquery datasource="#settings.getVar('dsn')#">
                	#preservesinglequotes(filecontents)#
                </cfquery>
                <cfset notes.note('Query succeeded on file : "#cleanfilename#"')>
            	<cfcatch>
  					<cfset notes.note('Query failed on  file : "#dbobjects.name#"<br>Message : "#cfcatch.detail#"')>
				</cfcatch>
            </cftry>
        </cfloop>
        
        <cfreturn notes.show()>
    </cffunction>
    
</cfcomponent>
