<cfcomponent displayname="fileindexable" extends="modules.search.indexable">
	
    <cffunction name="getlinktype">
		<cfreturn "external">
	</cffunction>
    
    <cffunction name="validate">
    
    </cffunction>
	
	<cffunction name="getpath">
		<cfargument name="machineroot">
		<cfreturn machineroot & variables.info.path>
	</cffunction>
    
    <cffunction name="saveforindex">
    	<cfset validate()>
    	<cfset variables.pageRef.saveFileIndexable(this)>
    </cffunction>
    
</cfcomponent>