<cfcomponent>
	<cffunction name="init">
    	<cfargument name="pageref" required="yes">
    	
		<cfset variables.pageref= arguments.pageref>
        
    	<cfset variables.info = structnew()>
        <cfset variables.info.linktype="internal">
		
        <cfreturn this>
	</cffunction>
    
    <cffunction name="setkey">
    	<cfargument name="key" required="true">
        <cfset variables.info.key = arguments.key>       
	</cffunction>
    
    <cffunction name="getkey">
		<cfreturn variables.info.key>
	</cffunction>
	
	 <cffunction name="setpath">
    	<cfargument name="path" required="true">
        <cfset variables.info.path = arguments.path>       
	</cffunction>
    
    <cffunction name="getpath">
		<cfreturn variables.info.path>
	</cffunction>
    
    <cffunction name="settitle">
    	<cfargument name="title" required="true">
        <cfset variables.info.title = arguments.title>
	</cffunction>
    
    <cffunction name="gettitle">
		<cfreturn variables.info.title>
	</cffunction>
    
    <cffunction name="setlinktype">
    	<cfargument name="type" required="true">
        <cfset variables.info.linktype = arguments.type>
	</cffunction>
    
    <cffunction name="getlinktype">
		<cfreturn variables.info.linktype>
	</cffunction>
    
    <cffunction name="setDescription">
    	<cfargument name="desc" required="true">
        <cfset variables.info.description = arguments.desc>
	</cffunction>
	
    <cffunction name="getDescription">
		<cfreturn variables.info.description>
	</cffunction>
</cfcomponent>