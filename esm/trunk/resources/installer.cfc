<cfcomponent name="installer">
	<cffunction name="init">
		<cfset var path = application.settings.getVar('machineroot')>
        <cfset var result = "">
    	<cfif NOT isdefined("url.install")>
        	<cfthrow message="install not called correctly">
        	<!--- 
				get all directories
				loop thru them,
				if install.cfc exists, invoke it.

			 --->
        </cfif>
        
        <cfif application.settings.isVarSet('debug') AND NOT application.settings.getvar('debug')>
        	<cfthrow message="not in debug mode">
        </cfif>

        <cfif fileexists(path &  trim(url.install) & '/install/installer.cfc')>
        	<cfset result = createObject('component', trim(url.install) & ".install.installer").init(application.settings).install(url.install)>
            <cfoutput>#result#</cfoutput>
            <cfabort>
        </cfif>
    
    	<cfreturn this>
    </cffunction>
</cfcomponent>