<cfcomponent extends="resources.abstractController" ouput="false">
	
    <cffunction name="init" output="false">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
        <cfset variables.pageindexables = arraynew(1)>
        <cfset variables.fileindexables = arraynew(1)>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="newPageIndexable">
    	<cfreturn createObject('component', "modules.search.pageIndexable").init(this)>
    </cffunction>
    
    <cffunction name="newFileIndexable">
    	<cfreturn createObject('component', "modules.search.fileIndexable").init(this)>
    </cffunction>
 
    <cffunction name="getPageIndexables">
    	<cfreturn variables.pageindexables>
    </cffunction>
    
    <cffunction name="getFileIndexables">
    	<cfreturn variables.fileindexables> 
    </cffunction>
    
    <cffunction name="saveFileIndexable">
    	<cfargument name="itm" required="yes">
    	<cfset arrayappend(variables.fileindexables, itm)> 
    </cffunction>
    
    <cffunction name="savePageIndexable">
    	<cfargument name="itm" required="yes">
    	<cfset arrayappend(variables.pageindexables, itm)> 
    </cffunction>
    
    <cffunction name="dump" output="yes">
    	<cfoutput>
        	page indexable count = #arraylen(pageindexables)#
        	file indexable count = #arraylen(fileindexables)#
        </cfoutput>
        <cfabort>
    </cffunction>
</cfcomponent>