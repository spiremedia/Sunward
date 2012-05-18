<cfcomponent name="miscdata">
	
    <cffunction name="init">
		<cfargument name="requestObject" required="yes">
        <cfset variables.requestObject = arguments.requestObject>
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="getItem">
    	<cfargument name="name" required="yes">
        
        <cfset var jsonObj = createObject('component','utilities.json').init()>
        <cfset var dt = "">
        
        <cfquery name="dt" datasource="#requestObject.getVar("dsn")#">
        	SELECT data
            FROM miscdata 
            WHERE name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
        </cfquery>
        
        <cfif dt.recordcount EQ 0>
        	<cfreturn "">
        </cfif>
        
        <cfreturn jsonObj.decode(dt.data)>
     </cffunction>
     
     <cffunction name="saveitem">
    	<cfargument name="name" required="yes">
        <cfargument name="value" required="yes">
        
        <cfset var jsonObj = createObject('component','utilities.json').init()>
        <cfset var dt = "">
        
        <cfset arguments.name = trim(arguments.name)>
        <cfset arguments.value = trim(arguments.value)>
        
        <cfquery name="dt" datasource="#requestObject.getVar("dsn")#">
        	SELECT COUNT(*) cnt 
            FROM miscdata 
            WHERE name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
        </cfquery>
        
        <cfif dt.cnt EQ 0>
        	<cfquery name="dt" datasource="#requestObject.getVar("dsn")#">
                INSERT INTO miscdata (
               		id, name, data
                ) VALUES (
                	<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#jsonObj.encode(arguments.value)#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
        <cfelse>
        	<cfquery name="dt" datasource="#requestObject.getVar("dsn")#">
                UPDATE miscdata SET
               		data = <cfqueryparam value="#jsonObj.encode(arguments.value)#" cfsqltype="cf_sql_varchar">
                WHERE 
                	name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfif>
       
     </cffunction>
     
</cfcomponent>