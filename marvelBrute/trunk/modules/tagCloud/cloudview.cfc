<cfcomponent name="cloudView">
	
	<cffunction name="init">
		<cfargument name="requestObject">
        
		<cfset variables.requestObject = arguments.requestObject>
        
		<cfreturn this>
	</cffunction>
    
    <cffunction name="setModel">
        <cfargument name="cloudMdl">
        <cfset variables.cloudMdl = arguments.cloudMdl>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>
        <cfset lcl.cloudQry = cloudMdl.getCloudItems()>
        <cfsavecontent variable="lcl.html">
        	<style>
				div.cloud a {text-decoration:none;}
				div.cloud a.cld1 {color:darkblue; font-size:10px;}
				div.cloud a.cld2 {color:green; font-size:12px;}
				div.cloud a.cld3 {color:orange; font-size:14px;}
				div.cloud a.cld4 {color:blue; font-size:16px;}
				div.cloud a.cld5 {color:purple; font-size:18px;}
				div.cloud a.cld6 {color:red; font-size:22px;}
			</style>
            <div class="cloud">
            	<cfif lcl.cloudQry.recordcount>
            	<cfoutput query="lcl.cloudQry">
                	<a class="cld#range#" href="/search/?criteria=#phrase#">#phrase#</a>
                </cfoutput>
                <cfelse>
                No cloud data.
                </cfif>
            </div>
        </cfsavecontent>
        <cfreturn lcl.html>
    </cffunction>
	
</cfcomponent>