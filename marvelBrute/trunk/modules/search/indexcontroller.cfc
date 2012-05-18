<cfcomponent extends="resources.abstractController" ouput="false">

	<cffunction name="init" output="false">
		<cfargument name="requestObject" required="yes">
		<cfargument name="collectionName" required="yes">

		<cfset variables.requestObject = arguments.requestObject>
       
        <cfset variables.aggregator = createobject('component','modules.search.searchableaggregator').init(requestObject)>
        
		<cfset variables.collection = createobject('component',"modules.search.collection").init(requestObject, collectionName)>
       
		<cfset variables.collection.loadIndexables(aggregateSearchables())>
        <cfset variables.collection.optimizeCollection()>
        
		<cfreturn this>
	</cffunction>
    
    <cffunction name="aggregateSearchables" output="false">
        <cfset var modules = application.modules.getModules()>
		
		<cfset var module = "">
		<cfset var moduleFolder = "">
		<cfset var moduleCntrler = "">
        <cfset var data = structnew()>
		<cfset data.view = 'indexing'>
		<cfloop list="#modules#" index="moduleFolder">
        	<cfif hasSearchables(moduleFolder)>
            	<cfset createObject('component','modules.#modulefolder#.controller').init(requestObject = variables.requestObject, data = data).getPagesforSiteSearch(variables.aggregator)>
            </cfif>
		</cfloop>
		<cfreturn variables.aggregator/>
	</cffunction>
    	  
    <cffunction name="hasSearchables">
    	<cfargument name="modulefolder" required="yes">
        <cfset var modulexml = "">
        <cfset var sitepath = requestObject.getVar('machineroot')>
		<cfif fileexists(sitepath & '/modules/' & moduleFolder & '/configxml.cfm')>
            <cfinclude template="../#moduleFolder#/configxml.cfm">
            <cfif structkeyexists(modulexml.moduleInfo.xmlattributes,'searchable') AND modulexml.moduleInfo.xmlattributes.searchable>
                <cfreturn true>
            </cfif>
        </cfif>
        <cfreturn false>
    </cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
    
</cfcomponent>