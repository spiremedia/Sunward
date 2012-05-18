<cfcomponent ouput="false">
	<cffunction name="init" output="false">
    	<cfargument name="requestObject">
		<cfargument name="mdl">
		<cfargument name="data">
		
        <cfset variables.requestObject = arguments.requestObject>
		<cfset variables.mdl = arguments.mdl>		
		<cfset variables.data = arguments.data>		
        <cfreturn this>
    </cffunction>
	
    <cffunction name="showHTML" output="false">
		<cfset var lcl = structnew()>
		
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<cfoutput>
					<p class="msg">
						Access Denied. You do not have permission to view this page. 
						Please call 1-888-898-3091 for support.  
					</p>
				</cfoutput>
			</div>
	    </cfsavecontent>
		<cfreturn lcl.html>
    </cffunction>
</cfcomponent>